<%-- 
    Document   : simulacion
    Created on : 13-nov-2016, 22:56:04
    Author     : Vicente
--%>

<%@page import="utils.Candidatura"%>
<%@page import="utils.Circunscripcion"%>
<%@page import="java.util.List"%>
<%@page import="utils.Eleccion"%>
<%@page import="utils.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Simulador de elecciones</title>
        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

        <!-- Optional theme -->
        <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css">
        <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Lobster">

        <link rel="stylesheet" href="./mycss.css">

        <!-- Latest compiled and minified JavaScript -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.2.2/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
        
        <!-- D3 para graficos -->
        <script type="text/javascript" src="./simulacion/resources/d3.min.js"></script>
        
        <!-- Javascript propios -->
	<script type="text/javascript" src="./simulacion/resources/leyDHondt.js"></script>
        <script type="text/javascript" src="./simulacion/resources/paginaSimulacion.js"></script>
	<script type="text/javascript" src="./simulacion/resources/grafico.js"></script>
        <script type="text/javascript" src="./simulacion/resources/jscolor.js"></script>
    </head>
    <body class="container-fluid" onload="doLoad();">
        <form id="form-simulacion" action="simulacion" method="post" onsubmit="return doSave();" class="row">
            <!-- Columna de configuración -->
            <div class="col-md-4" style="background-color: #ddf">
                <div class="sep-2"></div>
                <!-- Cargar archivo -->
                <p class="titulo">Cargar archivo</p>
                <div class="form-horizontal col-md-10">
                    <div class="form-group">
                        <select class="form-control">
                            <option>-</option>
                            <option>Elecciones España junio 2016</option>
                            <option>2</option>
                            <option>3</option>
                            <option>4</option>
                            <option>5</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <button type="button" class="btn btn-primary">Abrir</button>
                    </div>
                </div>
                <div class="clearflx">&nbsp</div>
                <hr>

                <!-- Configurar eleccion -->
                <p class="titulo">Detalles elección</p>
                <div class="form-horizontal col-md-11">
                    <div class="form-group">
                        <label for="tipo" class="col-sm-2 control-label">Tipo</label>
                        <div class="col-sm-10">
                            <select class="form-control" name="input-tipo-eleccion">
                                <option>-</option>
                                <option>Congreso Diputados</option>
                                <option>Autonomicas</option>
                                <option>Municipales</option>
                                <option>Parlamento Europeo</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="año" class="col-sm-2 control-label">Año</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="input-año">
                                <option>-</option>
                                <option>2016</option>
                                <option>2015</option>
                                <option>2014</option>
                                <option>2013</option>
                            </select>
                        </div>
                        <label for="mes" class="col-sm-1 control-label">Mes</label>
                        <div class="col-sm-5">
                            <select class="form-control" name="input-mes">
                                <option>-</option>
                                <option>Enero</option>
                                <option>Febrero</option>
                                <option>Marzo</option>
                                <option>Abril</option>
                                <option>Mayo</option>
                                <option>Junio</option>
                                <option>Julio</option>
                                <option>Abgosto</option>
                                <option>Septiembre</option>
                                <option>Octubre</option>
                                <option>Noviembre</option>
                                <option>Diciembre</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="n_rep" class="col-sm-4">Numero de representantes</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="n_rep" placeholder="ej:1000">
                        </div>
                    </div>
                </div>
                
                <div class="clearflx">&nbsp</div>
                <hr>

                <!-- Parametros simulacion -->
                <p class="titulo">Parametros simulación</p>
                <div class="form-horizontal col-md-11">
                    <div class="form-group">
                        <label for="umbral" class="col-sm-2">Porcentaje de mínima representacion</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="input-prop-min-representacion" onchange="actualizaPropMinRepresentacion(this);" value="0">
                        </div>
                    </div>
                </div>

                <div class="form-horizontal col-sm-11">
                    <div class="form-group">
                        <label for="circunscripcion" class="col-sm-4">Nueva circunscripción</label>
                        <div class="col-sm-5">
                            <input type="text" class="form-control" name="input-circunscripcion-nombre" placeholder="ej: Madrid">
                        </div>
                        <button type="button" class="btn btn-primary col-sm-2" onclick="nuevaCircunscripcion();">Añadir</button>
                    </div>
                </div>

                <div class="clearflx"></div>
                <div id="cuadrados-circunscripciones"></div>
                <div class="sep-2"></div>

                <div class="form-horizontal col-sm-11">
                    <div class="form-group">
                        <label for="candidatura" class="col-sm-4">Nueva candidatura</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" name="input-candidatura-nombre" placeholder="ej: Candidatura x">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-5">
                            <input class="jscolor" name="input-candidatura-color" value="">
                        </div>
                        <div class="col-sm-2 col-sm-offset-2">
                            <button type="button" class="btn btn-primary" onclick="nuevaCandidatura();">Añadir</button>
                        </div>
                    </div>
                </div>

                <div class="clearflx"></div>
                <div id="cuadrados-candidaturas"></div>
                <div class="clearflx">&nbsp</div>
            </div>

            <!-- Zona principal -->
            <div class="col-md-8">
                <div class="sep">
                    <p class="titulo"> Circunscripciones </p>
                    <div class="clearflx"></div>
                    <table class="table table-bordered" id="tabla-circunscripciones">
                        <thead>
                            <tr>
                                <th> Circunscripción </th>
                                <th> Total votos nulos </th>
                                <th> Total votos en blanco </th>
                                <th> Número de representantes </th>
                            </tr>
                        </thead>
                        <tbody id="tabla-circunscripciones-body">

                        </tbody>
                    </table>
                </div>
                <div class="sep">
                    <p class="titulo"> Votos </p>
                    <div class="clearflx"></div>
                    <table class="table table-bordered table-responsive" id="tabla-votos"></table>
                </div>

                <div class="sep">
                    <p class="titulo"> Simulación </p>
                    <div class="clearflx"></div>
                        <!-- Aquí aparecen los gráficos de la simulación -->
                        <div class="container-fluid">
                            <div class="row">
                                <div class="col-md-4" id="charts1"></div>
                            </div>
                            <div class="row">
                                <div class="col-md-8 col-md-offset-4" id="charts2"></div>
                            </div>
                            <button class="btn btn-primary" id="boton-inicio" onclick="inicioSimulacion()"> Iniciar </button>
                            <button class="btn btn-primary" id="boton-retroceso" onclick="retrocederSimulacion()" diplay="none"> < Anterior </button>
                            <button class="btn btn-primary" id="boton-avance" onclick="avanzarSimulacion()" diplay="none"> Siguiente > </button>
                            <button class="btn btn-primary" id="boton-avance-Fin" onclick="avanzarFinSimulacion()" diplay="none"> Fin >> </button>
                            
                            <button class="btn btn-primary" id="boton-Dentener" onclick="finSimulacion()" style="position: absolute; right: 0px" diplay="none"> Detener </button>
                        </div>
                </div>
            </div>
            
            <%
                Usuario usuarioActual = (Usuario) session.getAttribute("usuarioActual");
                if (usuarioActual != null) {
            %>
            <input type="submit" id="boton-submit" value="Almacenar datos"/>
                <%
                    Eleccion eleccion = (Eleccion) request.getAttribute("eleccion");
                    if (eleccion != null) {
                %>
            <div id="almacen" >
                <%
                        List<Circunscripcion> circunscripciones = (List<Circunscripcion>) request.getAttribute("circunscripciones");
                %>
                <input type="hidden" name="hidden-numero-circunscripciones" value="<%=circunscripciones.size()%>"/>
                <%
                        for (int i = 0; i < circunscripciones.size(); i++) {
                %>
                <input type="hidden" name="hidden-circunscripcion-nombre<%=i%>" value="<%=circunscripciones.get(i).getNombre()%>"/>
                <input type="hidden" name="hidden-circunscripcion-numero-representantes<%=i%>" value="<%=circunscripciones.get(i).getNumeroRepresentantes()%>"/>
                <input type="hidden" name="hidden-circunscripcion-voto-nulo<%=i%>" value="<%=circunscripciones.get(i).getVotoNulo()%>"/>
                <input type="hidden" name="hidden-circunscripcion-voto-en-blanco<%=i%>" value="<%=circunscripciones.get(i).getVotoEnBlanco()%>"/>
                <%
                        }

                        List<Candidatura> candidaturas = (List<Candidatura>) request.getAttribute("candidaturas");
                %>
                <input type="hidden" name="hidden-numero-candidaturas" value="<%=candidaturas.size()%>"/>
                <%
                        for (int i = 0; i < candidaturas.size(); i++) {
                %>
                <input type="hidden" name="hidden-candidatura-nombre-corto<%=i%>" value="<%=candidaturas.get(i).getNombreCorto()%>"/>
                <input type="hidden" name="hidden-candidatura-nombre-largo<%=i%>" value="<%=candidaturas.get(i).getNombreLargo()%>"/>
                <input type="hidden" name="hidden-candidatura-color<%=i%>" value="<%=candidaturas.get(i).getColor()%>"/>
                <%
                        }

                        int[][] votos = (int[][]) request.getAttribute("votos");
                        for (int i = 0; i < circunscripciones.size(); i++) {
                            for (int j = 0; j < candidaturas.size(); j++) {
                %>
                <input type="hidden" name="hidden-votos<%=i%><%=j%>" value="<%=votos[i][j]%>"/>
                <%

                            }
                        }
                %>
                <input type="hidden" name="hidden-prop-min-representacion" value="<%=circunscripciones.get(0).getMinimoRepresentacion()%>"/>
            </div>
                <%
                    }
                %>
            <%
                }
            %>
        </form>
    </body>
</html>
