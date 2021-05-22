# Pruebas automatizadas E2E - ABP Ghost


## Funcionalidades
- Crear post: Se prueba la funcionalidad para la creación de post, asi como su modificación y eliminación.
- Crear página: Se prueba la funcionalidad para la creación de página, asi como su modificación y eliminación.
- Crear tag: Se prueba la funcionalidad para la creación de tag, asi como su modificación y eliminación.
- Busqueda: Funcionalidad que permite buscar post, paginas.
- Contraseña: Funcionalidad para cambiar contraseña
- Nombre sitio: Funcionalidad de configuración del sitio.
- Navegación: Agregar elementos nuevos de navegación en el sitio.

## Escenarios probados


<table><tbody><tr><td><strong>Escenario</strong>&nbsp;</td><td><strong>Descripción</strong>&nbsp;</td></tr><tr><td align="center">1&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, crear un post con titulo y cuerpo con una cadena alfanumerica aleatoria, se publica el post creado, cerrar la sesion del usuario administrador, ingresar a la pagina principal del frontend para validar la publicación del post.&nbsp;</td></tr><tr><td align="center">2&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, crear un tag con un nombre y una descripción alfanumerica aleatoria, se ingresa a la pagina de TAGS y se valida la creación del elemento.&nbsp;</td></tr><tr><td align="center">3&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, crear un post con titulo y cuerpo con una cadena alfanumerica aleatoria, consulta la lista de post, seleccionar el post creado y eliminarlo, consultar la lista de post y validar que se haya eliminado el post elegido.&nbsp;</td></tr><tr><td align="center">4&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, crear una página con titulo y cuerpo con una cadena alfanumerica aleatoria, se verifica que la pagina creada se encuentre en el listado de paginas, .&nbsp;</td></tr><tr><td align="center">5&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, crear una página con titulo y cuerpo con una cadena alfanumerica aleatoria, se verifica que la pagina creada se encuentre en el listado de paginas, selecciona una página y se elimina, consultar la lista de páginas y validar que se haya eliminado la página.&nbsp;</td></tr><tr><td align="center">6&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, crear un tag con un nombre y una descripción, se ingresa a la pagina de TAGS y se valida la creación del elemento, selecciona el TAG recien creado y se elimina, consulta la lista de TAGS y valida que se haya eliminado el TAG elegido.&nbsp;</td></tr><tr><td align="center">7&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, ingresar a perfil de usuario introducir contraseña actual, nueva contraseña alfanumerica y se confirma, cerrar la sesion del usuario administrador e ingresar con la nueva contraseña.&nbsp;</td></tr><tr><td align="center">8&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, crear una página con titulo y cuerpo con una cadena alfanumerica aleatoria, se verifica que la pagina creada se encuentre en el listado de paginas, selecciona la página creada y se modifca el titulo, consultar la lista de páginas y valida que se haya modificado el titulo de la página seleccionada.&nbsp;</td></tr><tr><td align="center">9&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, crear un post con titulo y cuerpo con una cadena alfanumericos aleatorios, consulta la lista de post, selecciona el post recien creado y se modifica el titulo, consulta la lista de post y valida que se haya modificado el titulo del post elegido..&nbsp;</td></tr><tr><td align="center">10&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, Crear un tag con un nombre y una descripción alfanumericos aleatorios, se ingresa a la pagina de TAGS y se valida la creación del elemento, selecciona el TAG creado y se modifica el nombre, Se ingresa a la pagina de TAGS y se valida la modificación del nombre del TAG.&nbsp;</td></tr><tr><td align="center">11&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, crear un post con titulo y cuerpo con un  Busa cadena alfanumerica aleatoria, crear un tag con un nombre y una descripción alfanumericos aleatorios, publicar el post creado, consulta la lista de TAGS y validar que se haya creado el TAG ingresado al crear el post.&nbsp;</td></tr><tr><td align="center">12&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, crear un post con titulo y cuerpo con una cadena alfanumerica aleatoria, consultar la lista de post, seleccionar el post recien creado y lo despublica, consulta la lista de post y validar que se haya desplublicado el post elegido.&nbsp;</td></tr><tr><td align="center">13&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, seleccionar la opción de configuración y elegir general, expandir la opción titulo y descipción, ingresa nuevo nombre de sitio alfanumerico y se confirma, cerrar la sesion del usuario administrador, ingresar a la pagina principal del frontend para el cambio de nombre del sitio.&nbsp;</td></tr><tr><td align="center">14&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, crear un post con titulo y cuerpo con una cadena alfanumerica aleatoria, busca los post que coinciden con el nombre del post recien creado, muestra el detalle del post seleccionado mediante la opción de busqueda.&nbsp;</td></tr><tr><td align="center">15&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, crear una página con titulo y cuerpo con una cadena alfanumerica aleatoria, busca las paginas que coinciden con el nombre de la página recien creada, muestra el detalle de la pagina seleccionada mediante la opción de busqueda.&nbsp;</td></tr><tr><td align="center">16&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, Crear un tag con un nombre y una descripción alfanumericos aleatorios, consulta la lista de TAGS que coinciden con el nombre del TAG recien creado, muestra el detalle del TAG seleccionado mediante la opción de busqueda.&nbsp;</td></tr><tr><td align="center">17&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, ingresar a perfil de usuario introducir nuevo nombre aleatorio alfanumerico, cerrar la sesion del usuario administrador e ingresar nuevamente para validar el nombre en perfil de usuario.&nbsp;</td></tr><tr><td align="center">18&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, ingresar a perfil de usuario, ingresa la contraseña antigua correcta, ingresa contraseña nueva y en campo de confirmación una nueva erronea, introducir contraseña nueva y confirmación iguales y cambiar contraseña.&nbsp;</td></tr><tr><td align="center">19&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, crear un tag con un nombre y una descripción alfanumericos aleatorios, crear un post con titulo y cuerpo con una cadena alfanumericos aleatorios, se asocia post con tag recien creado.&nbsp;</td></tr><tr><td align="center">20&nbsp;</td><td align="justify">Ingresar con usuario y password valido al sitio de administrador, ingresar a settings y luego diseño, agregar un navegación al sitio web www.uniandes.edu.co y guardar, cerrar la sesion del usuario administrador, ingresar a la pagina principal del frontend para validar el nuevo enlace.&nbsp;</td></tr>
</tbody></table>


## Integrantes equipo
- Clayderman Josue Rojas Jimenez  - cjrojas1@uniandes.edu.co
- Daniel Alberto Larios Torres    - dlarios@uniandes.edu.co
- Hector Fabio Varón Bonilla      - h.varon@uniandes.edu.co
- Rafael David Matiz Cortes       - r.matiz@uniandes.edu.co


## Instrucciones para ejecutar los escenarios de prueba con Kraken

<strong>1.	Crear un directorio vacío e ingresar a él.  Para ello ejecute los siguientes comandos en un terminal:</strong>

<code>mkdir semana5</code><br>
<code>cd semana5</code>

<strong>2.	Configurar bundle.  Para ello ejecute:</strong>

<code>bundle init</code>

<strong>3.	Editar manualmente el archivo Gemfile para asegurar que quede con el siguiente contenido:</strong>

<pre>
# frozen_string_literal: true

source "https://rubygems.org"

gem 'rubyzip', '1.2.1'
gem 'kraken-mobile', path: '[ruta_instalables_kraken]'

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# gem "rails"
</pre>

Reemplazar <code>[ruta_instalables_kraken]</code> por la ruta dónde se encuentra instalado el directorio de kraken

<strong>4.	Instalar las dependencias</strong>

<code>bundle install --path vendor/bundle</code><br>
<code>bundle install</code><br>
<code>bundle exec kraken-mobile gen</code><br>
<code>sudo gem install faker</code>

<strong>5.	Generar el Proyecto base en Kraken</strong>

<code>bundle exec kraken-mobile gen</code><br>
Presionar -Enter-<br>
<code>bundle exec kraken-mobile setup</code><br>
Presionar 2 luego -Enter- -Enter-

<strong>6.	Reemplazar la definición de pasos</strong>

Para ello, tome el archivo <code>kraken/features/web/step_definitions/web_steps.rb</code> de la entrega y reemplácelo en la ruta respectiva dentro de la carpeta (es decir, en la ruta <code>semana5/features/web/step_definitions/</code> del ejemplo)

Modifique el archivo <code>web_steps.rb</code> (previamente colocado en <code>semana5/features/web/step_definitions/</code>) y edite las primeras líneas del archivo reemplazando los valores respectivos para la instalación de Ghost dónde se ejecutará la prueba:

<code>USER_NAME</code>: correo electrónico del usuario administrador<br>
<code>PASSWORD</code>: contraseña del usuario administrador<br>
<code>NEW_PASSWORD</code>: Nueva contraseña para el usuario administrador (para escenario de pruebas 07)<br>
<code>NEW_PASSWORD2</code>: Contraseña diferente a la nueva para confirmación (para escenario de pruebas 18)<br>
<code>BASE_URL</code>: URL base de la instalación de Ghost

<strong>7.	Instalar cada escenario de pruebas y ejecutarlo</strong>

Para ello, tome cada archivo <code>kraken/features/ghost[#N].feature</code> (dónde [#N] es el número del escenario de prueba) de la entrega y colóquelo en la ruta respectiva dentro de la carpeta (es decir, en la ruta <code>semana5/features/</code> del ejemplo).

Desde el directorio base del proyecto (directorio semana5 del ejemplo) ejecute el caso de prueba:

<code>bundle exec kraken-mobile run</code><br>

Observe y evalúe la ejecución del escenario de prueba.

<i>Nota 1</i>: se recomienda dejar sólo un escenario de pruebas para ejecución en el directorio feature para cada uno de los escenarios de prueba a ejecutar.<br><br>
<i>Nota 2</i>: luego de ejecutar escenario de pruebas 07, asegúrese que en el archivo <code>web_steps.rb</code> el valor de la variable <code>PASSWORD</code> contenta la nueva contraseña (Valor que se asignaría en la variable <code>NEW_PASSWORD</code>)<br><br>
<i>Nota 3</i>: asegure que en el archivo <code>web_steps.rb</code> los valores de las variables <code>NEW_PASSWORD</code> y <code>NEW_PASSWORD2</code> tengan valores diferentes con cadenas de mínimo 10 caracteres.

