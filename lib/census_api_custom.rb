class CensusApiCustom

  def call(document_type, document_number)
    response = nil
    get_document_number_variants(document_type, document_number).each do |variant|

      response = Response.new(get_response_body(document_type, variant))
      return response if response.valid?
    end
    response
  end

  def get_document_number_variants(document_type, document_number)
    # Delete all non-alphanumerics
    document_number = document_number.to_s.gsub(/[^0-9A-Za-z]/i, '')
    variants = []

    if is_dni?(document_type)
      document_number, letter = split_letter_from(document_number)
      number_variants = get_number_variants_with_leading_zeroes_from(document_number, 9)
      letter_variants = get_letter_variants(number_variants, letter)

      variants += number_variants
      variants += letter_variants
    else # if not a DNI, just use the document_number, with no variants
      variants << document_number
    end

    variants
  end

  class Response
    def initialize(body)
      @body = body
    end

    def valid?
      !@body.nil?
    end

    def date_of_birth
      str = data[:nacim_fecha]
      # GET-10 - Rest API return date with time and timezone always set to 0
       year, month, day = str.match(/(\d\d\d?\d?)\D(\d\d?)\D(\d\d?)(T00:00:00.000Z)?/)[1..3]
      return nil unless day.present? && month.present? && year.present?
      Date.new(year.to_i, month.to_i, day.to_i)
    end

    def postal_code
      data[:codigo_postal]
    end

    def district_code
      nil
    end

    def gender
      'male'
    end

    private

      def data
        @body
      end
  end

  private

    def get_response_body(document_type, document_number)
      if end_point_available?
        begin
          JSON.parse(client(document_number).get.body).symbolize_keys
        rescue RestClient::NotFound => ex
          nil
        rescue Exception => ex
          # Notify to support
          nil
        end
      else
        stubbed_response_body
      end
    end

    def client(document_number)
      @client = RestClient::Resource.new("#{Rails.application.secrets.census_api_end_point}/#{document_number}")
    end

    def request(document_type, document_number)
      { request:
        { codigo_institucion: Rails.application.secrets.census_api_institution_code,
          codigo_portal:      Rails.application.secrets.census_api_portal_name,
          codigo_usuario:     Rails.application.secrets.census_api_user_code,
          documento:          document_number,
          tipo_documento:     document_type,
          codigo_idioma:      102,
          nivel: 3 }}
    end

    def end_point_available?
      true || Rails.env.staging? || Rails.env.preproduction? || Rails.env.production?
    end

    def stubbed_response_body
      {get_habita_datos_response: {get_habita_datos_return: {hay_errores: false, datos_habitante: { item: {fecha_nacimiento_string: "31-12-1980", identificador_documento: "12345678Z", descripcion_sexo: "Varón" }}, datos_vivienda: {item: {codigo_postal: "28013", codigo_distrito: "01"}}}}}
    end

    def is_dni?(document_type)
      document_type.to_s == "1"
    end

    def split_letter_from(document_number)
      letter = document_number.last
      if letter[/[A-Za-z]/] == letter
        document_number = document_number[0..-2]
      else
        letter = nil
      end
      return document_number, letter
    end

    # if the number has less digits than it should, pad with zeros to the left and add each variant to the list
    # For example, if the initial document_number is 1234, and digits=8, the result is
    # ['1234', '01234', '001234', '0001234']
    # Custom
    # GET-10 Number of digits set to 9 because of available census API needs it
    def get_number_variants_with_leading_zeroes_from(document_number, digits=9)
      document_number = document_number.to_s.last(digits) # Keep only the last x digits
      document_number = document_number.gsub(/^0+/, '')   # Removes leading zeros

      variants = []
      variants << document_number unless document_number.blank?
      while document_number.size < digits
        document_number = "0#{document_number}"
        variants << document_number
      end
      variants
    end

    # Generates uppercase and lowercase variants of a series of numbers, if the letter is present
    # If number_variants == ['1234', '01234'] & letter == 'A', the result is
    # ['1234a', '1234A', '01234a', '01234A']
    def get_letter_variants(number_variants, letter)
      variants = []
      if letter.present? then
        number_variants.each do |number|
          variants << number + letter.downcase << number + letter.upcase
        end
      end
      variants
    end
end
