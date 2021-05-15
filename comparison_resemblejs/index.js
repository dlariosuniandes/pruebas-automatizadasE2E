const compare = require("resemblejs").compare;
const config = require("./config.json");
const fs = require('fs');

//Valores de config.json
const { viewportHeight, viewportWidth, browsers, options, foldersForComparison, comparisonReport } = config;

//Resultados del proceso por escenario (directorio) y por pasos (imágenes)
let data_array = []

//Consecutivo de cada registro de comparación de imágenes
let reportItemIndex = 0


//Construye el código HTML para cada registro de comparación de imágenes (pasos de escenario)
//Acordeón de bootstrap
function paintIdItem (data) {
  reportItemIndex = reportItemIndex + 1;
  
  return `<div class="accordion-item">
    <h2 class="accordion-header" id="heading${reportItemIndex}">
      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${reportItemIndex}" aria-expanded="false" aria-controls="collapse${reportItemIndex}">
        ${data[0]}
      </button>
    </h2>
    <div id="collapse${reportItemIndex}" class="accordion-collapse collapse" aria-labelledby="heading${reportItemIndex}" data-bs-parent="#accordionExample">
      <div class="accordion-body">
      ${data[1].map(item => paintReportItem(item))}
      </div>
    </div>
  </div>`
}

//Construye el código HTML para cada comparación de carpetar (escenario)
function paintReportItem(elem) {

  return `<div class="browser">
    <div class=" btitle">
    </div>
    <div class="imgline">
      <div class="imgcontainer">
        <span class="imgname">File name</span>
        <pre>${elem[4]}</pre>
      </div>
      <div class="imgcontainer">
        <span class="imgname">3.3.0</span>
        <img class="img2" src="${elem[0]}" id="refImage" label="3.3.0">
      </div>
      <div class="imgcontainer">
        <span class="imgname">3.42.5</span>
        <img class="img2" src="${elem[1]}" id="testImage" label="3.42.5">
      </div>
      <div class="imgcontainer">
        <span class="imgname">Diff</span>
        <img class="img2" src="${elem[2]}" id="diffImage" label="Diff">
      </div>
      <div class="imgcontainer">
        <span class="imgname">Info</span>
        <pre>
        Difference: ${elem[3].misMatchPercentage} %
        Analisis time: ${elem[3].analysisTime} ms
        </pre>
      </div>
    </div>
  </div>`;

}

//Generación del reporte
function writeReportRecord() {

  //Al nombre del archivo de reporte en HTML se le incluye el timestamp para unicidad
  let filename = config.comparisonReport + 'report.' + Date.now() + '.html'

  console.log("Generating report: " + filename);

  fs.writeFileSync(filename, `<html>
        <head>
            <style>
.browser {
    position: relative;
    margin: 5px auto;
    padding: 10px 30px;
    background-color: #FAFAFA;
    box-shadow: 0 3px 6px 0 rgba(0,0,0,0.16);
    min-height: 40px;
    -webkit-break-inside: avoid;
    break-inside: avoid;
}
.btitle {
    padding: 5px 0;
}
.imgline {
    position: relative;
    display: -webkit-box;
    display: -webkit-flex;
    display: -ms-flexbox;
    display: flex;
}
.imgcontainer {
    -webkit-flex: 1 1 auto;
    -ms-flex: 1 1 auto;
    flex: 1 1 auto;
    padding: 0 25px;
    padding-top: 20px;
    text-align: center;
}
.imgname {
    text-align: center;
    font-family: latoregular;
    color: #787878;
    display: block;
    margin: 0 auto;
    text-transform: uppercase;
    padding: 5px 0;
    padding-bottom: 15px;
    font-size: 12px;
}
.img2 {
    width:100%;
}
            </style>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-eOJMYsd53ii+scO/bJGFsiCZc+5NDVN2yr8+0RDqr0Ql0h+rP48ckxlpbzKgwra6" crossorigin="anonymous">
            <title> VRT Report </title>
        </head>
        <body>
            <h1>Report</h1>
<div class="accordion" id="accordionExample">
 ${data_array.map( data => paintIdItem(data) )}
</div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/js/bootstrap.bundle.min.js" integrity="sha384-JEW9xMcG8R+pH31jmWH6WWP0WintQrMb4s7ZOdauHnUtxwoG2vI5DkLtS3qm9Ekf" crossorigin="anonymous"></script>
        </body>
    </html>`);
}

//Proceso de comparación de directorios
async function executeComparison(){
  
  /*
  Información de cada par de directorios para comparar (escenarios) de config.json
  */
  let folders = config.foldersForComparison;

  folders.forEach ( folder => {
    /*
    * folder.id: identificador del par de directorios a comparar (identificador del escenario de pruebas)
    * folder.from: directorio base a comparar
    * folder.to: directorio objetivo contra la cual comparar
    * folder.compared: directorio dónde se almacenarán los archivos resultados de la comparación
    */
    console.log("Comparing folders: ");
    console.log(folder.from);
    console.log("<->");
    console.log(folder.to);
    
    //Se leen los archivos del directorio base a comparar.  Deben ser los mismos en nombre y cantidad que existen en el  directorio objetivo
    let files = fs.readdirSync(folder.from);
    
    //Se almacena información del resultado de la comparación por directorio por cada archivo, los cuales son insumos para la generación del reporte
    let item = []
    files.map ( async file => {
      
      /*
        Se forma la ruta completa de los archivos de imagen involucrados en el proceso de comparación
        * fileFrom: ruta del archivo de imagen base de comparación
        * fileTo: ruta del archivo de imagen objetivo contra el cual comparar
        * fileFrom: ruta del archivo de imagen que se generará con el resultado de la comparación de los dos archivos de imagen anteriores
      */
      
      let fileFrom = folder.from + file;
      let fileTo = folder.to + file;
      let fileCompared = folder.compared + file;
      
      //Comparación sincrónica realizada por ResembleJS
      compare(fileFrom, fileTo, options, function(err, data) {
        if (err) {
          console.log("An error!");
        }
        else {
          //Se genera el archivo de imagen de resultado de la comparación
          fs.writeFileSync(folder.compared + file, data.getBuffer());
          
          //Se agrega el resultado de la comparación correspondiente de cada archivo por directorio (paso de escenario)
          item.push([fileFrom, fileTo, fileCompared, data, file])
        }
      });
    });
    
    //Se agrega el resultado de la comparación de los archivos para el directosio (escenario)
    data_array.push([folder.id, item])

  });
}

//Punto de inicio
(async () => {
  await executeComparison();
  writeReportRecord();
})();
