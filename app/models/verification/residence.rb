class Verification::Residence
  include ActiveModel::Model
  include ActiveModel::Dates
  include ActiveModel::Validations::Callbacks

  attr_accessor :user, :document_number, :document_type, :date_of_birth, :postal_code, :terms_of_service

  before_validation :call_census_api

  validates_presence_of :document_number
  validates_presence_of :document_type
  validates_presence_of :date_of_birth
  validates_presence_of :postal_code
  validates :terms_of_service, acceptance: { allow_nil: false }
  validates :postal_code, length: { is: 5 }

  validate :allowed_age
  validate :document_number_uniqueness

  def initialize(attrs={})
    self.date_of_birth = parse_date('date_of_birth', attrs)
    attrs = remove_date('date_of_birth', attrs)
    super
    clean_document_number
  end

  def save
    return false unless valid?
    user.update(document_number:       document_number,
                document_type:         document_type,
                geozone:               self.geozone,
                date_of_birth:         date_of_birth.to_datetime,
                gender:                gender,
                residence_verified_at: Time.current)
  end

  def allowed_age
    return if errors[:date_of_birth].any?
    errors.add(:date_of_birth, I18n.t('verification.residence.new.error_not_allowed_age')) unless self.date_of_birth <= User.minimum_required_age.years.ago
  end

  def document_number_uniqueness

    errors.add(:document_number, I18n.t('errors.messages.taken')) if User.where(document_number: valid_variants).any?
  end

  # WIll calculate all variants to avoid repeat
  def valid_variants

    CensusApiCustom.new.get_document_number_variants(document_type, document_number_from_census + document_number_letter)
  end

  def store_failed_attempt
    FailedCensusCall.create({
      user: user,
      document_number: document_number,
      document_type:   document_type,
      date_of_birth:   date_of_birth,
      postal_code:     postal_code
    })
  end


  def document_number_from_census
    @census_api_response.document_number_from_census
  end

  def document_number_letter
    @census_api_response.document_number_letter
  end

  def geozone
    Geozone.where(census_code: district_code).first
  end

  def district_code
    @census_api_response.district_code
  end

  def gender
    @census_api_response.gender
  end

  private

    def call_census_api
      @census_api_response = CensusApiCustom.new.call(document_type, document_number)
    end

    def residency_valid?
        # GET-44 Customer requirements about residence check
        @census_api_response.valid? && @census_api_response.date_of_birth == date_of_birth
    end

    def clean_document_number
      self.document_number = self.document_number.gsub(/[^a-z0-9]+/i, "").upcase unless self.document_number.blank?
    end

end
