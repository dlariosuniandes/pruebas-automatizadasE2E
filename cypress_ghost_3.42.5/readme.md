Para correr este repositorio es necesario contar con 
node 12.10 y una version de ghost 3.3.0 instalada de manera
local o remota.

1. Hacer npm install en la raiz del repo
2. Cambian en el archivo cypress.json las variables de env 
a las utilizadas en su plataforma ghost, se requieren, nombre,
email y password utilizado
3. ./node_modules/.bin/cypress open 
para correr las pruebas en la gui de cypress o 
./node_modules/.bin/cypress run
para correrlas desde terminal en modo headless