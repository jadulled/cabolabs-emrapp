<html>
  <head>
    <meta name="layout" content="main" />
    <title>Registro de signos</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'css/ui-lightness', file: 'jquery-ui-1.8.24.custom.css')}" />
    <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'emr.css')}" />
    <style type="text/css">
      body {
        padding: 10px;
        margin-top: 10px;
      }
      h1 {
        border-bottom: 1px solid #DFDFDF;
        padding-bottom: 5px;
      }
      form {
        margin: 0 17%;
      }
      form > table {
        border: 0; /* saca el border top de la table que lo puse como border bottom del h1 */
      }
      .content {
        /*padding: 10px;*/
      }
      td {
        white-space:nowrap;
      }
      tr > td:first-child {
        text-align: right;
      }
      tr:last-child td {
        /*text-align: center;*/
      }
      input[type=radio] {
        margin: 0 5px 0 0;
      }
      input[readonly=readonly] {
        border: 0;
        background: none;
      }
      label {
        margin: 0 5px 0 5px;
      }
      .units_constraint {
        display: none;
      }
    </style>
    <g:javascript src="jquery-1.8.2.min.js" />
    <g:javascript src="jquery-ui-1.8.24.autocomplete.min.js" />
    
    <g:javascript>
    
    $(document).ready(function() {
      
    });
    
    $("input[type=radio]").live( "click", function () {
    
      var name = $(this).attr("name"); // ej. presion_sistolica_units
      var pos = name.lastIndexOf("_");
      var field = name.substring(0,pos); // queda presion_sistolica
      
      
      // habria que apagar si hay alguno mostrandose ahora
      //temperatura_units_constraint
      $( "#"+field+"_units_constraint" ).children().hide(); // esconde todas las constraints
      
      
      // id="temperatura_(cdvq_item.units)"
      $( "#"+field+"_"+$(this).val() ).show();
      
      
      //console.log( $(this).val() );
      //console.log($(this).attr("name").lastIndexOf("_"));
    });
    
    </g:javascript>
  </head>
  <body>
    <div class="nav" role="navigation">
      <ul>
        <li><g:link class="list" controller="registros" action="currentSession">Registros</g:link></li>
      </ul>
      <g:render template="/user/loggedUser" />
    </div>
    
    <g:render template="patientData" model="${session.clinicalSession.datosPaciente}" />
  
    <h1>Registro de signos</h1>

    <div class="content">
      <g:form action="save">
        <input type="hidden" name="archetypeId" value="${archetype.archetypeId.value}"/>
        
        <table>
          <g:set var="node" value="${archetype.node( bindings['create_registro_signos']['presion_sistolica'])}" />
          <tr>
            <td>
              Presión sistólica:
              <g:if test="${node?.list.size() == 1}">
                <g:if test="${node.list[0].magnitude}">
                (${node?.list[0].magnitude.lower}..${node?.list[0].magnitude.upper})
                </g:if>
              </g:if>
              <g:else>
                TODO: al cambiar la unidad seleccionada, poner el rango respectivo si esta definido.
              </g:else>
            </td>
            <td>
              <input type="text" name="presion_sistolica_mag" id="presion_sistolica_mag" />
            </td>
            <td>
              <%--
              ${bindings['create_registro_signos']['presion_sistolica_units']}<br/>
              ${node} CDvQuantity<br/>
              ${node?.list} List CDvQuantityItem<br/>
              --%>
             
              <%--
              TODO: si hay un solo item, mostrarlo como label con hidden
              TODO: taglib
              --%>
              <g:if test="${node?.list.size() == 1}">
                <input type="text" value="${node?.list[0].units}" readonly="readonly" name="presion_sistolica_units" />
              </g:if>
              <g:else>
                <g:each in="${node?.list}" var="item">
                  
                  <%--
                  ${item as grails.converters.XML}
                  /* item:
                    <?xml version="1.0" encoding="UTF-8"?>
                    <CDvQuantityItem>
                      <class>org.openehr.am.openehrprofile.datatypes.quantity.CDvQuantityItem</class>
                      <magnitude>
                        <class>org.openehr.rm.support.basic.Interval</class>
                        <lower>0.0</lower><lowerIncluded>true</lowerIncluded>
                        <lowerUnbounded>false</lowerUnbounded>
                        <upper>400.0</upper>
                        <upperIncluded>true</upperIncluded>
                        <upperUnbounded>false</upperUnbounded>
                      </magnitude>
                      <precision />
                      <units>mm[Hg]</units>
                    </CDvQuantityItem>
                  */
                  --%>
                    
                  <label><input type="radio" value="${item.units}" name="presion_sistolica_units" />${item.units}</label>
                </g:each>
              </g:else>
            </td>
          </tr>
          
          <g:set var="node" value="${archetype.node( bindings['create_registro_signos']['presion_diastolica'])}" />
          <tr>
            <td>
              Presión diastólica:
              <g:if test="${node?.list.size() == 1}">
                <g:if test="${node.list[0].magnitude}">
                (${node?.list[0].magnitude.lower}..${node?.list[0].magnitude.upper})
                </g:if>
              </g:if>
              <g:else>
                TODO: al cambiar la unidad seleccionada, poner el rango respectivo si esta definido.
              </g:else>
            </td>
            <td>
              <input type="text" name="presion_diastolica_mag" id="presion_diastolica_mag" />
            </td>
            <td>
              <g:if test="${node?.list.size() == 1}">
                <input type="text" value="${node?.list[0].units}" readonly="readonly" name="presion_diastolica_units" />
              </g:if>
              <g:else>
                <g:each in="${node?.list}" var="item">
                  <label><input type="radio" value="${item.units}" name="presion_diastolica_units" />${item.units}</label>
                </g:each>
              </g:else>
            </td>
          </tr>
          
          <g:set var="node" value="${archetype.node( bindings['create_registro_signos']['temperatura'])}" />
          <tr>
            <td>
              Temperatura:
              
              <span id="temperatura_units_constraint">
	             <g:if test="${node?.list.size() == 1}">
	               <g:if test="${node.list[0].magnitude}">
	                 (${node?.list[0].magnitude.lower}..${node?.list[0].magnitude.upper})
	               </g:if>
	             </g:if>
	             <g:else>
	               <g:each in="${node.list}" var="cdvq_item">
	                 <span class="units_constraint" id="temperatura_${cdvq_item.units}">
	                   <g:if test="${node.list[0].magnitude}">
	                     (${cdvq_item.magnitude.lower}..${cdvq_item.magnitude.upper})
	                   </g:if>
	                 </span>
	               </g:each>
	             </g:else>
              </span>
            </td>
            <td>
              <input type="text" name="temperatura_mag" id="temperatura_mag" />
            </td>
            <td>
              <g:if test="${node?.list.size() == 1}">
                <input type="text" value="${node?.list[0].units}" readonly="readonly" name="temperatura_units" />
              </g:if>
              <g:else>
                <g:each in="${node?.list}" var="item">
                  <label><input type="radio" value="${item.units}" name="temperatura_units" />${item.units}</label>
                </g:each>
              </g:else>
            </td>
          </tr>
          
          <g:set var="node" value="${archetype.node( bindings['create_registro_signos']['frecuencia_cardiaca'])}" />
          <tr>
            <td>
              Frecuencia cardíaca:
              <g:if test="${node?.list.size() == 1}">
                <g:if test="${node.list[0].magnitude}">
                (${node?.list[0].magnitude.lower}..${node?.list[0].magnitude.upper})
                </g:if>
              </g:if>
              <g:else>
                TODO: al cambiar la unidad seleccionada, poner el rango respectivo si esta definido.
              </g:else>
            </td>
            <td>
              <input type="text" name="frecuencia_cardiaca_mag" id="frecuencia_cardiaca_mag" />
            </td>
            <td>
              <g:if test="${node?.list.size() == 1}">
                <input type="text" value="${node?.list[0].units}" readonly="readonly" name="frecuencia_cardiaca_units" />
              </g:if>
              <g:else>
                <g:each in="${node?.list}" var="item">
                  <label><input type="radio" value="${item.units}" name="frecuencia_cardiaca_units" />${item.units}</label>
                </g:each>
              </g:else>
            </td>
          </tr>
          
          <g:set var="node" value="${archetype.node( bindings['create_registro_signos']['frecuencia_respiratoria'])}" />
          <tr>
            <td>
              Frecuencia respiratoria:
              <g:if test="${node?.list.size() == 1}">
                <g:if test="${node.list[0].magnitude}">
                (${node?.list[0].magnitude.lower}..${node?.list[0].magnitude.upper})
                </g:if>
              </g:if>
              <g:else>
                TODO: al cambiar la unidad seleccionada, poner el rango respectivo si esta definido.
              </g:else>
            </td>
            <td>
              <input type="text" name="frecuencia_respiratoria_mag" id="frecuencia_respiratoria_mag" />
            </td>
            <td>
              <g:if test="${node?.list.size() == 1}">
                <input type="text" value="${node?.list[0].units}" readonly="readonly" name="frecuencia_respiratoria_units" />
              </g:if>
              <g:else>
                <g:each in="${node?.list}" var="item">
                  <label><input type="radio" value="${item.units}" name="frecuencia_respiratoria_units" />${item.units}</label>
                </g:each>
              </g:else>
            </td>
          </tr>
          
          <g:set var="node" value="${archetype.node( bindings['create_registro_signos']['peso'])}" />
          <tr>
            <td>
              Peso:
              <g:if test="${node?.list.size() == 1}">
                <g:if test="${node.list[0].magnitude}">
                  (${node?.list[0].magnitude.lower}..${node?.list[0].magnitude.upper})
                </g:if>
              </g:if>
              <g:else>
                TODO: al cambiar la unidad seleccionada, poner el rango respectivo si esta definido.
              </g:else>
            </td>
            <td>
              <input type="text" name="peso_mag" id="peso_mag" />
            </td>
            <td>
              <g:if test="${node?.list.size() == 1}">
                <input type="text" value="${node?.list[0].units}" readonly="readonly" name="peso_units" />
              </g:if>
              <g:else>
                <g:each in="${node?.list}" var="item">
                  <label><input type="radio" value="${item.units}" name="peso_units" />${item.units}</label>
                </g:each>
              </g:else>
            </td>
          </tr>
          
          <g:set var="node" value="${archetype.node( bindings['create_registro_signos']['estatura'] )}" />
          <tr>
            <td>
              Estatura:
              <g:if test="${node?.list.size() == 1}">
                <g:if test="${node.list[0].magnitude}">
                  (${node?.list[0].magnitude.lower}..${node?.list[0].magnitude.upper})
                </g:if>
              </g:if>
              <g:else>
                TODO: al cambiar la unidad seleccionada, poner el rango respectivo si esta definido.
              </g:else>
            </td>
            <td>
              <input type="text" name="estatura_mag" id="estatura_mag" />
            </td>
            <td>
              <g:if test="${node?.list.size() == 1}">
                <input type="text" value="${node?.list[0].units}" readonly="readonly" name="estatura_units" />
              </g:if>
              <g:else>
                <g:each in="${node?.list}" var="item">
                  <label><input type="radio" value="${item.units}" name="estatura_units" />${item.units}</label>
                </g:each>
              </g:else>
            </td>
          </tr>
          <tr>
            <td></td>
            <td></td>
            <td><input type="submit" value="Guardar" /></td>
          </tr>
        </table>
      </g:form>
    </div>
  </body>
</html>