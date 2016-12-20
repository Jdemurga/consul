# coding: utf-8
# Default admin user (change password after first deploy to a server!)


admin_password = Rails.application.secrets.consul_admin_default_pass
admin_email = Rails.application.secrets.consul_admin_default_email
raise "Not administrator password or email suplied, please configure it" unless admin_password|| admin_email

if Administrator.count == 0 && !Rails.env.test?
  admin = User.create!(username: 'admin_getafe', email: admin_email, password: admin_password, password_confirmation: admin_password, confirmed_at: Time.current, terms_of_service: "1")
  admin.create_administrator
end

# Names for the moderation console, as a hint for moderators
# to know better how to assign users with official positions
Setting["official_level_1_name"] = "Empleados públicos"
Setting["official_level_2_name"] = "Organización Municipal"
Setting["official_level_3_name"] = "Directores generales"
Setting["official_level_4_name"] = "Concejales"
Setting["official_level_5_name"] = "Alcaldesa"


Setting["support_email"] = "participa@getafe.es"

# Max percentage of allowed anonymous votes on a debate
Setting["max_ratio_anon_votes_on_debates"] = 50

# Max votes where a debate is still editable
Setting["max_votes_for_debate_edit"] = 1000

# Max votes where a proposal is still editable
Setting["max_votes_for_proposal_edit"] = 1000

# Max length for comments
Setting['comments_body_max_length'] = 1000

# Prefix for the Proposal codes
Setting["proposal_code_prefix"] = 'GET'

# Number of votes needed for proposal success
Setting["votes_for_proposal_success"] = 53726

# Months to archive proposals
Setting["months_to_archive_proposals"] = 12

# Users with this email domain will automatically be marked as level 1 officials
# Emails under the domain's subdomains will also be included
Setting["email_domain_for_officials"] = ''

# Code to be included at the top (header) of every page (useful for tracking)
Setting['per_page_code'] =  ''

# Social settings
Setting["twitter_handle"] = nil
Setting["twitter_hashtag"] = nil
Setting["facebook_handle"] = nil
Setting["youtube_handle"] = nil
Setting["blog_url"] = nil

# Public-facing URL of the app.
Setting["url"] = "https://consul.getafe.es"

# Consul installation's organization name
Setting["org_name"] = "Participa Getafe"

# Consul installation place name (City, Country...)
Setting["place_name"] = "Getafe"

# Feature flags
Setting['feature.debates'] = false
Setting['feature.spending_proposals'] = true
Setting['feature.twitter_login'] = false
Setting['feature.facebook_login'] = false
Setting['feature.google_login'] = false
Setting['feature.public_stats'] = false

# Spending proposals feature flags
Setting['feature.spending_proposal_features.voting_allowed'] = false

# Banner styles
Setting['banner-style.banner-style-one']   = "Banner style 1"
Setting['banner-style.banner-style-two']   = "Banner style 2"
Setting['banner-style.banner-style-three'] = "Banner style 3"

# Banner images
Setting['banner-img.banner-img-one']   = "Banner image 1"
Setting['banner-img.banner-img-two']   = "Banner image 2"
Setting['banner-img.banner-img-three'] = "Banner image 3"

# Proposal notifications
Setting['proposal_notification_minimum_interval_in_days'] = 3
Setting['direct_message_max_per_day'] = 3


puts "Creating Geozones"
centro = Geozone.create(name: "Centro")
norte = Geozone.create(name: "Getafe Norte")
alhondiga = Geozone.create(name: "Alhóndiga")
perales = Geozone.create(name: "Perales del Río")
cierva = Geozone.create(name: "Juan de la Cierva")
bercial = Geozone.create(name: "Bercial")
margaritas = Geozone.create(name: "Margaritas")
isidro = Geozone.create(name: "San Isidro")
buenavista = Geozone.create(name: "Buenavista")
molinos = Geozone.create(name: "Los Molinos")
sector3 = Geozone.create(name: "Sector III")

puts "Creating Tags Categories"

ActsAsTaggableOn::Tag.create!(name:  "Asociaciones", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Cultura", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Deportes", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Derechos Sociales", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Economía", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Empleo", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Equidad", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Sostenibilidad", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Participación", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Movilidad", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Medios", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Salud", featured: true , kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Transparencia", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Seguridad y Emergencias", featured: true, kind: "category")
ActsAsTaggableOn::Tag.create!(name:  "Medio Ambiente", featured: true, kind: "category")



puts "Creating 2016 spending proposals"

# Cerrar las votaciones en la herramienta
Setting["feature.spending_proposal_features.voting_allowed"] = false
Setting["feature.spending_proposal_features.open_results_page"] = true

# Propuestas de gasto
# Margaritas
SpendingProposal.create(
  title: 'Remodelación de la confluencia en la c/velarde con c/sánchez morate',
  geozone: margaritas,
  description: 'El diseño final de la propuesta tendrá que analizarse en detalle, garantizando los espacios necesarios para
los peatones, el acceso de los vehículos de urgencia y el giro de los autobuses que pasan por ese punto.',
  external_url: 'http://getafe.es/wp-content/uploads/prepar16_margaritas_inv_1.pdf',
  price: 226000,
  author_id: admin.id,
  feasible: true,
  terms_of_service: '1',
  created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
    title: 'Plan de acerado y pasos de peatones',
    geozone: margaritas,
    description: 'Mejora de las aceras deterioradas e implementación de pasos de peatones',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_margaritas_inv_5.pdf',
    price: 300000-226000,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
    title: 'Formación para jóvenes en el ámbito del ocio y tiempo libre, participación y asociacionismo',
    geozone: margaritas,
    description: 'Jornadas formativas sobre el ámbito relacionado, educación en valores y habilidades sociales.',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_margaritas_pro_2.pdf',
    price: 12000,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

# Centro
SpendingProposal.create(
    title: 'Pinturas muro campaña concienciación Alzheimer',
    geozone: centro,
    description: '<strong>CEN-INV-08</strong> Ejecución de pinturas en Muro para concienciación Enfermedad Alzheimer.',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_centro_inv_4.pdf',
    price: 20000,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
    title: 'Arreglo calle Griñón',
    geozone: centro,
    description: '<strong>CEN-INV-11</strong> Arreglo de calzada y aceras',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_centro_inv_6.pdf',
    price: 92352.53,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
    title: 'Reparación pavimento CEIP San José de Calasanz',
    geozone: centro,
    description: '<strong>CEN-INV-06</strong> Indican los proponentes que el pavimento no cumple requisitos de seguridad y debe ser subsanado.',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_centro_inv_3.pdf',
    price: 27416.15,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
    title: 'Acondicionamiento calle Madrid',
    geozone: centro,
    description: '<strong>CEN-INV-04</strong> Aumento de la iluminación, papeleras, bancos y elementos decorativos.',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_centro_inv_2.pdf',
    price: 27416.15,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
    title: 'Programación estable cultural en época primaveral y estival dirigido al público familiar',
    geozone: centro,
    description: 'No encontrado',
    external_url: '',
    price: 12000,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

# alhóndiga
SpendingProposal.create(
    title: 'Proyecto de reactivación y adecuación del Parque de La Alhóndiga',
    geozone: alhondiga,
    description: '<strong>ALH-INV-08</strong>
<p>Intervención integral en el Parque Alhóndiga para reactivación y mejora del uso y disfrute de los vecinos y vecinas, a saber:</p>
<ul>
<li>
Adecuación de sendas.
</li>
<li>
Implementación de mobiliario urbano (mesas de ajedrez, sombra artificial en determinados lugares con implementación de bancos,...)
</li>
<li>
Zona deportiva Cross Fitt con vallado perimetral.
</li>
<li>
Zona deportiva y recreativa con elementos adaptados.
</li>
<li>
Adecuación del Campo de Beisbol situado tras el Complejo Deportivo Municipal Alhóndiga-Sector III.
</li>
<li>
Adecuación del lago para posibilitar la pesca deportiva y la instalación de un Cable-esquí.
</li>
</ul>',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_alhondiga_inv_6.pdf',
    price: 100000,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )


SpendingProposal.create(
    title: 'Arreglo y ensanche de las aceras en calle Fray Diego Ruiz',
    geozone: alhondiga,
    description: '<strong>ALH-INV-04</strong><p>Actuación de reparación del acerado de la Calle Fray Diego Ruiz y ensanchamiento en las dimensiones técnicamente posibles</p>',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_alhondiga_inv_2.pdf',
    price: 130000,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
    title: 'Salida para la circulación desde calle Pato a calle Estudiantes',
    geozone: alhondiga,
    description: '<strong>ALH-INV-06</strong><p>Propuesta para aliviar los problemas de circulación en Calle Oca ya que a efectos prácticos la entrada y salida a la misma se hace por Avda. Reyes Católicos. Se trata de dar salida a la C/ Pato por C/Estudiantes.</p>',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_alhondiga_inv_4.pdf',
    price: 5000,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
    title: 'Instalación de columpios impulsivos',
    geozone: alhondiga,
    description: '<strong>ALH-INV-03</strong><p>Adaptación completa o parcial de las Zonas Infantiles del Barrio equipándolas con columpios inclusivos para infancia con movilidad reducida temporal o permanente y sin ninguna dificultad de movilidad. Dotar de pavimento en el que la movilidad de una silla de ruedas sea posible. Equipación adicional de las siguientes áreas:</p>
    <ul><li>Plaza Príncipe de Vergara</li><li>Plaza Rufino Castro</li><li>C/ Alondra con Paseo Alonso de Mendoza</li><li>Plaza Tirso de Molina</li><li>C/ Cóndor con Paseo Alonso de Mendoza</li><li> Plaza colindante con C/ Fray Diego Ruiz, Pintor Rosales y Alonso de Mendoza</li><li>Plaza Greco</li></ul>',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_alhondiga_inv_4.pdf',
    price: 68486.45,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
    title: 'Atención psicológica gratuita grupal',
    geozone: alhondiga,
    description: '<strong>ALH-PRO-05</strong><p>Atención psicológica dirigida a niños, adolescentes y adultos para el aumento de competencias, aumento de recursos psicoemocionales potenciando una eficaz adaptación a las situaciones vitales</p>',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_alhondiga_pro_4.pdf',
    price: 12000,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

# Norte
SpendingProposal.create(
    title: 'Mejora de la accesibilidad de los pasos de peatones',
    geozone: norte,
    description: '<strong>GET-INV-05 Y OTROS</strong><p>Intervención integral para la eliminación de barreras arquitectónicas y mejora de la movilidad en pasos de peatones ubicados en el Barrio Getafe Norte, se manifiesta cómo enclaves prioritarios los situados en:</p>
    <ul><li>Avda. Los Ébanos con C/ Melocotón</li><li>Avda. Los Ébanos con Avda. Los Arces</li><li>Avda. Los Ébanos, 63 (entrada Colegio)</li><li>C/ de la Morera, hay dos pasos de peatones</li><li>C/ Montesori con Avda. Rigoberta Menchú</li><li>Avda. Los Arces (el del Ahorramás)</li></ul>',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_gnorte_inv_2.pdf',
    price: 52318.36,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
    title: 'Arreglo acera avenida del Casar',
    geozone: norte,
    description: '<strong>GET-INV-07</strong><p>Intervención en el acerado de esta avenida que presenta irregularidades discontinuas en su trazado.</p>',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_gnorte_inv_3.pdf',
    price: 52318.36,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
    title: 'Adecuación de sendas en Parque Castilla-La Mancha (acceso a IES Menéndez Pelayo y barrio de Las Margaritas)',
    geozone: norte,
    description: '<strong>GET-INV-07</strong><p>Adecuación de pequeños caminos que "de hecho" existen por el uso, cuyo trazado discurre por el Parque Castilla La Mancha y que dan acceso al Instituto de Educación Secundaria Menéndez Pelayo y el Barrio Margaritas.</p>',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_gnorte_inv_8.pdf',
    price: 36606.55,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
    title: 'Mejora del alumbrado de la calle Francisca Sauquillo',
    geozone: norte,
    description: '<strong>GET-INV-20</strong><p>Implementación y mejora del alumbrado en la Calle Francisca Sauquillo.</p>',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_gnorte_inv_9.pdf',
    price: 8853.47,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
title: 'Programación estable cultural en época primaveral y estival dirigido al público familiar',
geozone: norte,
description: '',
external_url: '',
price: 12000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )

# PERALES
SpendingProposal.create(
title: 'Equipamiento escenario centro cultural del barrio',
geozone: perales,
description: '<strong>PR-INV-05 Y OTROS</strong><p>Dotar al escenario del Centro Cultural de telón y cortinajes, habilitar espacio de escena y tras escena, juego de luces, tramoya, equipo de sonido y posibilidad de oscurecer el Patio de Butacas.</p>',
external_url: 'http://getafe.es/wp-content/uploads/prepar16_perales_inv_2.pdf',
price: 50000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
    title: 'Ampliación superficies deportivas anexas al campo de fútbol',
    geozone: perales,
    description: '<strong>PR-INV-09 Y OTROS</strong><p>Varios proponentes vecinos del Barrio de Perales del Río proponen la construcción de pistas deportivas anexas al Campo de Fútbol ya existente en este orden de prelación:</p>
    <ul><li>Pistas de Pádel</li><li>Pistas de Tenis</li><li>Skate Park</li></ul>',
    external_url: 'http://getafe.es/wp-content/uploads/prepar16_perales_inv_4.pdf',
    price: 255354.01,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )


    SpendingProposal.create(
    title: 'Programación estable cultural en época primaveral y estival dirigido al público familiar',
    geozone: perales,
    description: 'Sin especificar',
    external_url: nil,
    price: 12000,
    author_id: admin.id,
    feasible: true,
    terms_of_service: '1',
    created_at: '2016-06-31', valuation_finished: true )

# Cierva
SpendingProposal.create(
title: 'Intervención parcial en el centro cívico Juan de la Cierva',
geozone: cierva,
description: '<strong>JC-INV-11</strong><p>Necesidad de ejecución de algunas tareas de reforma así como de dotación de equipamiento respetando la prelación de las necesidades</p>
<ul><li>Tarima en el gimnasio, reposición de telón en el escenario, instrumentos musicales,...</li><li>Reposición de carpintería y cristalería interior y exterior</li><li> Reparación de la grada. Pintura.</li></ul>',
external_url: 'http://getafe.es/wp-content/uploads/prepar16_jcierva_inv_7.pdf',
price: 290000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
title: 'Acondicionamiento del acceso a la Parroquia Nuestra Señora del Cerro (calle Salamanca)',
geozone: cierva,
description: '<strong>JC-INV-06</strong><p>Facilitar el acceso a los locales parroquiales mediante la eliminación de las escaleras laterales y construcción de rampas</p>',
external_url: 'http://getafe.es/wp-content/uploads/prepar16_jcierva_inv_4.pdf',
price: 9586.37,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
title: 'Programación estable cultural en época primaveral y estival dirigido al público familiar',
geozone: cierva,
description: '<strong>JC-PRO-05</strong><p>Se establecen dos líneas de trabajo:</p><ul><li> Reducción y gestión de los conflictos interpersonales, grupales y entre organizaciones presentes en el desarrollo de la convivencia de las actividades del Centro Cívico</li><li>Apoyo, identificación y trabajo de calle para las situaciones de bulling y acoso escolar en medio abierto de los centros IES Laguna de Joatzel e IES Satafi. Trabajo en los espacios externos del centro</li></ul>',
external_url: 'http://getafe.es/wp-content/uploads/prepar16_jcierva_pro_1.pdf',
price: 12000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )


# Bercial
SpendingProposal.create(
title: 'Proyecto de rehabilitación y mejora del CEIP Seseña Benavente',
geozone: bercial,
description: '<strong>BER-INV-04 Y OTROS</strong><p>Se propone tres ejes fundamentales de actuación prioritaria: renovación integral de la fachada del Pabellón de Primaria, incorporación de baños a las aulas de Infantil y acondicionamiento de patios bajo criterios de calidad y seguridad</p>',
external_url: 'http://getafe.es/wp-content/uploads/prepar16_bercial_inv_3.pdf',
price: 304516.74,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
title: 'Programación estable cultural en época primaveral y estival dirigido al público familiar',
geozone: bercial,
description: 'Sin especificar',
external_url: nil,
price: 12000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )


# Isidro
SpendingProposal.create(
title: 'Recuperación y rehabilitación de ‘la Era’ (antiguas pistas deportivas y zona anexa)',
geozone: isidro,
description: '<strong>SI-INV-03 Y OTROS</strong><p>Rehabilitación de la zona para el ocio y esparcimiento de los vecinos del barrio, entre otros:</p>
<ul><li>Tratamiento (reparación o reposición) del pavimento.</li><li>Adecentamiento del distinto vallado.</li><li>Reparación de jardineras. Acondicionamiento de zona verde.</li><li> Dotar las pistas con juegos o equipamiento deportivo que la cubierta permita</li><li>Mobiliario urbano (bancos,..)</li><li>Kiosko Bar si fuera posible</li></ul>',
external_url: 'http://getafe.es/wp-content/uploads/prepar16_sanisidro_inv_2.pdf',
price: 63941.53,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
title: 'Mejora de la accesibilidad al centro cívico San Isidro',
geozone: isidro,
description: '<strong>SI-INV-04 Y OTROS</strong><p>Exponen los proponentes que el acceso al Centro Cívico del barrio presenta condiciones mejorables. Relativas sobre todo a la puerta de acceso, el paso y la accesibilidad.</p>',
external_url: 'http://getafe.es/wp-content/uploads/prepar16_sanisidro_inv_1.pdf',
price: 250000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
title: 'Programación estable cultural en época primaveral y estival dirigido al público familiar',
geozone: isidro,
description: 'Sin especificar',
external_url: nil,
price: 12000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )


# molinos
SpendingProposal.create(
title: 'Ampliación zona deportiva EQ8',
geozone: molinos,
description: '<strong>LM-INV-05</strong><p>Se propone ampliar la zona deportiva de la Parcela EQ8, complementándola con juegos deportivos cómo mesas fijas de Pin Pon o Ajedrez.</p>',
external_url: 'http://getafe.es/wp-content/uploads/prepar16_molinos_inv_4.pdf',
price: 220000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
title: 'Barrera de árboles filtradores de partículas',
geozone: molinos,
description: '<strong>LM-INV-17</strong><p>Propuesta de plantación de hileras de elevada altura potencial en la región sur del barrio para que actúen de pantalla protectora (hacia C/ Gran Sultana)</p>',
external_url: 'http://getafe.es/wp-content/uploads/prepar16_molinos_inv_6.pdf',
price: 80000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
title: 'Programación estable cultural en época primaveral y estival dirigido al público familiar',
geozone: molinos,
description: 'Sin especificar',
external_url: nil,
price: 7000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
title: 'Proceso participado',
geozone: buenavista,
description: 'Sin especificar',
external_url: nil,
price: 5000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )


#Buenavista
SpendingProposal.create(
title: 'Propuesta mixta',
geozone: buenavista,
description: '<strong></strong><p></p>',
external_url: 'http://getafe.es/areas-de-gobierno/area-social/participacion-ciudadana/actuaciones/presupuestos-participativos/proceso-de-votaciones-de-presupuestos-participativos-mayo-junio-2016/presupuestos-participativos-propuestas-aceptadas-buenavista/',
price: 220000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
title: 'Arreglo de las gradas de madera',
geozone: buenavista,
description: '<strong>BUE-INV-31</strong><p>Arreglo de las gradas de madera de la plaza sita entre las calles María Lejárraga, José Giral, Santiago Casares y Federico Melchor.</p>',
external_url: 'http://getafe.es/wp-content/uploads/prepar16_buenavista_inv_10.pdf',
price: 60000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
title: 'Programación estable cultural en época primaveral y estival dirigido al público familiar',
geozone: buenavista,
description: 'Sin especificar',
external_url: nil,
price: 12000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )


# Sector III
SpendingProposal.create(
title: 'Adecuación de huerto urbano educativo y aula en la naturaleza',
geozone: sector3,
description: '<strong>S3-INV-10</strong><p>Se propone la creación de un huerto urbano colaborativo con implementación de talleres para divulgar conocimientos relativos al medio ambiente y el uso sostenible de recursos.</p>',
external_url: 'http://getafe.es/wp-content/uploads/prepar16_sector3_inv_2.pdf',
price: 125000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )


SpendingProposal.create(
title: 'Espacio de promoción y creación de artistas en CC Sector III',
geozone: sector3,
description: '<strong>S3-INV-07</strong><p>Se propone ligera ampliación del Centro Cívico Sector III por la "zona de tierras" próxima al Centro de poesía José Hierro para la creación de un espacio específico para trabajo de artistas locales.</p>',
external_url: 'http://getafe.es/wp-content/uploads/prepar16_sector3_inv_1.pdf',
price: 180000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )

SpendingProposal.create(
title: 'Ampliación de actividades para personas mayores de 65 años',
geozone: sector3,
description: '<strong>S3-PRO-01</strong><p>Apunta el proponente que dado que en el barrio esta población cada vez es más numerosa se pretende aumentar las actividades dirigidas a esta población: senderismo, tenis, pádel, salidas culturales,...</p>',
external_url: 'http://getafe.es/wp-content/uploads/prepar16_sector3_pro_1.pdf',
price: 12000,
author_id: admin.id,
feasible: true,
terms_of_service: '1',
created_at: '2016-06-31', valuation_finished: true )
