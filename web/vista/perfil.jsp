<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="modelo.pedido"%>
<%@page import="java.util.List"%>
<%
    List<modelo.pedido> misPedidos = (List<pedido>) request.getAttribute("listaMispedidos");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mi Perfil</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Font -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Luxurious+Roman&display=swap" rel="stylesheet">

        <!-- Iconos -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="icon" href="recursos/logo_cora.png">

        <!-- Alertify -->
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/alertify.min.css"/>
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/themes/default.min.css"/>

        <!-- CSS -->
        <link rel="stylesheet" href="estilos/estilos.css">
        <link rel="stylesheet" href="estilos/piestilo.css">

        <style>
            .tabla-pedidos-scroll{
                max-height: 390px;
                overflow-y: auto;
                overflow-x: auto;
                border: 1px solid #f2dfdd;
                border-radius: 12px;
            }

            .tabla-pedidos-scroll thead th{
                position: sticky;
                top: 0;
                z-index: 2;
                background-color: #faf8f5 !important;
                color: #7c6753;
                box-shadow: 0 1px 0 #f2dfdd;
            }

            .resumen-box{
                background: #faf8f5;
                border: 1px solid #f2dfdd;
                border-radius: 14px;
                padding: 20px 14px;
                height: 100%;
                transition: .2s ease;
            }

            .resumen-box:hover{
                transform: translateY(-2px);
                box-shadow: 0 8px 18px rgba(124,103,83,.08);
            }

            .resumen-num{
                font-size: 1.9rem;
                font-weight: 700;
                color: #7c6753;
                line-height: 1;
            }

            .resumen-label{
                margin-top: 8px;
                color: #8c7766;
                font-size: .95rem;
            }

            .mini-resumen{
                background: #fff;
                border: 1px solid #eadede;
                border-radius: 12px;
                padding: 14px 16px;
                min-height: 88px;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }

            .mini-titulo{
                font-size: .85rem;
                color: #9a8777;
                margin-bottom: 4px;
                display: block;
            }

            .sin-resultados{
                display: none;
                background: #faf8f5;
                border: 1px dashed #dcc8d1;
                border-radius: 12px;
                padding: 14px;
                color: #8c7766;
                text-align: center;
                margin-top: 12px;
            }
            .contenedor-grafico-cliente{
                position: relative;
                width: 100%;
                height: 260px; 
                max-height: 260px;
            }

            @media (max-width: 768px){
                .contenedor-grafico-cliente{
                    height: 220px;
                    max-height: 220px;
                }
            }
            @media (max-width: 991px){
                .tabla-pedidos-scroll{
                    max-height: 520px;
                }
            }
        </style>
    </head>

    <body>
        <%
            request.setAttribute("paginaActual", "perfil");
        %>

        <jsp:include page="/componentes/encabezado.jsp" />

        <main class="container mt-5 pt-4" style="margin-top: 180px; margin-bottom: 150px;">
            <h2 class="mb-4 text-center text-dark font-luxurious">Mi Perfil</h2>

            <div class="row g-4 mt-4">

                <!-- ===================== PRIMERA FILA ===================== -->
                <!-- RESUMEN -->
                <div class="col-lg-8">
                    <div class="card-historia h-100">
                        <h3 class="mb-4 subcora" style="border-bottom: 2px solid #f2dfdd; padding-bottom: 10px;">
                            Resumen de pedidos
                        </h3>

                        <div class="row g-3">
                            <div class="col-md-3 col-6">
                                <div class="resumen-box text-center">
                                    <div class="resumen-num">${totalPedidosCliente}</div>
                                    <div class="resumen-label">Total pedidos</div>
                                </div>
                            </div>

                            <div class="col-md-3 col-6">
                                <div class="resumen-box text-center">
                                    <div class="resumen-num">${pedidosPendientesCliente}</div>
                                    <div class="resumen-label">Pendientes</div>
                                </div>
                            </div>

                            <div class="col-md-3 col-6">
                                <div class="resumen-box text-center">
                                    <div class="resumen-num">${pedidosCursoCliente}</div>
                                    <div class="resumen-label">En curso</div>
                                </div>
                            </div>

                            <div class="col-md-3 col-6">
                                <div class="resumen-box text-center">
                                    <div class="resumen-num">${pedidosEntregadosCliente}</div>
                                    <div class="resumen-label">Entregados</div>
                                </div>
                            </div>
                        </div>

                        <div class="row g-3 mt-2">
                            <div class="col-md-4">
                                <div class="mini-resumen">
                                    <span class="mini-titulo">Último pedido</span>
                                    <strong>${empty ultimoPedidoCliente ? 'Sin pedidos aún' : ultimoPedidoCliente}</strong>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="mini-resumen">
                                    <span class="mini-titulo">Método más usado</span>
                                    <strong>${empty metodoFavoritoCliente ? 'Sin datos' : metodoFavoritoCliente}</strong>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="mini-resumen">
                                    <span class="mini-titulo">Tipo frecuente</span>
                                    <strong>${empty tipoEntregaFavoritoCliente ? 'Sin datos' : tipoEntregaFavoritoCliente}</strong>
                                </div>
                            </div>
                        </div>
                        <div class="mt-4">
                            <div class="mini-resumen">
                                <span class="mini-titulo mb-2">Mis productos más solicitados</span>

                                <div class="contenedor-grafico-cliente">
                                    <canvas id="graficoProductosCliente"></canvas>
                                </div>

                                <c:if test="${empty productosTopCliente}">
                                    <div class="text-center text-muted mt-3">
                                        Aún no hay datos suficientes para mostrar el gráfico.
                                    </div>
                                </c:if>
                            </div>
                        </div>    
                    </div>
                </div>

                <!-- MIS DATOS -->
                <div class="col-lg-4">
                    <div class="card-valor text-center h-100">
                        <h3 class="mb-4 subcora" style="border-bottom: 2px solid #f2dfdd; padding-bottom: 10px; text-align: left;">
                            Mis Datos
                        </h3>

                        <c:set var="fotoPerfil" value="${empty sessionScope.imagen ? 'cuenta.jpg' : sessionScope.imagen}" />
                        <img src="${pageContext.request.contextPath}/recursos/${fotoPerfil}" 
                             class="img-fluid rounded-circle mb-4 shadow-sm mx-auto" alt="Foto de perfil" 
                             style="object-fit: cover; width: 140px; height: 140px; border: 3px solid #f2dfdd;">

                        <div class="px-4">
                            <div class="text-start mb-3">
                                <label class="form-label fw-bold" style="color: #7c6753;">Usuario</label>
                                <div class="p-2" style="background-color: #faf8f5; border: 1px solid #dcc8d1;">
                                    ${datosUsuario.nombreusuario}
                                </div>
                            </div>

                            <div class="text-start mb-3">
                                <label class="form-label fw-bold" style="color: #7c6753;">Correo Electrónico</label>
                                <div class="p-2" style="background-color: #faf8f5; border: 1px solid #dcc8d1;">
                                    ${datosUsuario.correo}
                                </div>
                            </div>

                            <div class="text-start mb-4">
                                <label class="form-label fw-bold" style="color: #7c6753;">Teléfono</label>
                                <div class="p-2" style="background-color: #faf8f5; border: 1px solid #dcc8d1;">
                                    ${datosUsuario.telefono}
                                </div>
                            </div>
                        </div>

                        <div class="text-center mt-4 pt-4 px-4 mb-4" style="border-top: 1px dashed #dcc8d1;">
                            <p class="small text-muted mb-3">
                                ¿Deseas cambiar tus datos de perfil? Ponte en contacto con nuestro equipo.
                            </p>
                            <a href="controladorcontacto?accion=listar" class="btn btn-primary w-100 py-2">
                                Contáctanos
                            </a>
                        </div>
                    </div>
                </div>

                <!-- ===================== SEGUNDA FILA ===================== -->
                <div class="col-12">
                    <div class="card-historia">
                        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3 mb-4"
                             style="border-bottom: 2px solid #f2dfdd; padding-bottom: 12px;">

                            <h3 class="subcora m-0">Mis pedidos</h3>

                            <div class="d-flex flex-column flex-md-row gap-2 w-100 justify-content-lg-end">

                                <!-- buscador -->
                                <div class="input-group" style="max-width: 250px;">
                                    <span class="input-group-text bg-white border-end-0">
                                        <i class="fa-solid fa-magnifying-glass"></i>
                                    </span>
                                    <input type="text"
                                           id="buscarPedidoPerfil"
                                           class="form-control border-start-0"
                                           placeholder="Buscar por código, dirección, pago...">
                                </div>

                                <!-- filtro estado -->
                                <select id="filtroEstadoPedidoPerfil" class="form-select" style="max-width: 190px;">
                                    <option value="">Todos los estados</option>
                                    <option value="pendiente">Pendiente</option>
                                    <option value="curso">En curso</option>
                                    <option value="entregado">Entregado</option>
                                    <option value="cancelado">Cancelado</option>
                                </select>

                                <!-- orden -->
                                <select id="ordenPedidoPerfil" class="form-select" style="max-width: 220px;">
                                    <option value="reciente">Más reciente primero</option>
                                    <option value="antiguo">Más antiguo primero</option>
                                    <option value="estadoAZ">Estado A - Z</option>
                                    <option value="estadoZA">Estado Z - A</option>
                                    <option value="tipoAZ">Tipo de entrega A - Z</option>
                                    <option value="pagoAZ">Método de pago A - Z</option>
                                </select>
                            </div>
                        </div>

                        <div class="table-responsive tabla-pedidos-scroll">
                            <table class="table align-middle text-center mb-0" id="tablaPedidosPerfil" style="border-color: #f2dfdd;">
                                <thead style="background-color: #faf8f5; color: #7c6753;">
                                    <tr>
                                        <th>Cód.</th>
                                        <th>Dirección</th>
                                        <th>Delivery</th>
                                        <th>Tipo</th>
                                        <th>Pago</th>
                                        <th>Estado</th>
                                        <th>Entrega estimada</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>

                                <tbody id="tbodyPedidosPerfil">
                                    <%
                                    if (misPedidos != null && !misPedidos.isEmpty()) {
                                        for (pedido p : misPedidos) {
                                            String mensaje = "";
                                            double monto = p.getCosto_delivery();

                                            if ("fisico".equalsIgnoreCase(p.getTipo_entrega())) {
                                                mensaje = "No aplica";
                                            } else {
                                                if (monto == 0) {
                                                    mensaje = "Por definirse";
                                                } else {
                                                    mensaje = "S/. " + String.format("%.2f", monto);
                                                }
                                            }

                                            String est = (p.getEstado() != null) ? p.getEstado().toLowerCase() : "";
                                            String badgeStyle = "";

                                            if (est.equals("pendiente")) badgeStyle = "color: #b8860b; font-weight: bold;";
                                            else if (est.equals("curso")) badgeStyle = "color: #a68b6d; font-weight: bold;";
                                            else if (est.equals("entregado")) badgeStyle = "color: #556b2f; font-weight: bold;";
                                            else if (est.equals("cancelado")) badgeStyle = "color: #B1564E; text-decoration: line-through;";
                                    %>
                                    <tr style="background-color: #ffffff;"
                                        data-id="<%=p.getId_pedido()%>"
                                        data-direccion="<%= p.getDireccion() != null ? p.getDireccion().toLowerCase() : "" %>"
                                        data-delivery="<%= mensaje.toLowerCase() %>"
                                        data-tipo="<%= p.getTipo_entrega() != null ? p.getTipo_entrega().toLowerCase() : "" %>"
                                        data-pago="<%= p.getMetodo_pago() != null ? p.getMetodo_pago().toLowerCase() : "" %>"
                                        data-estado="<%= est %>">

                                        <td class="fw-bold" style="color: #a68b6d;">#<%=p.getId_pedido()%></td>
                                        <td style="text-transform: capitalize;"><%=p.getDireccion().toLowerCase()%></td>
                                        <td><%= mensaje %></td>
                                        <td style="text-transform: capitalize;"><%=p.getTipo_entrega()%></td>
                                        <td style="text-transform: capitalize;"><%= p.getMetodo_pago() %></td>

                                        <td>
                                            <span style="<%= badgeStyle %> text-transform: capitalize;"><%= est %></span>
                                        </td>

                                        <td>
                                            <% if ("cancelado".equals(est)) { %>
                                                <span style="color: #B1564E; font-weight: bold;">Cancelado</span>
                                            <% } else if ("pendiente".equals(est)) { %>
                                                <span>Por definirse</span>
                                            <% } else if (("curso".equals(est) || "entregado".equals(est)) && p.getFechaEntregaMin() == null) { %>
                                                <span>Sin fecha aún</span>
                                            <% } else if (p.getFechaEntregaMin() != null) { %>
                                                <span><%= p.getFechaEntregaMin() %> - <%= p.getFechaEntregaMax() %></span>
                                            <% } else { %>
                                                <span>Por definirse</span>
                                            <% } %>
                                        </td>

                                        <td class="text-nowrap">
                                            <div class="d-flex gap-1 justify-content-center flex-wrap">
                                                <button type="button" class="btn btn-primary btn-sm py-1 px-2"
                                                        onclick="abrirDetalle(<%=p.getId_pedido()%>)">
                                                    <i class="fa-solid fa-eye fa-sm"></i>
                                                </button>

                                                <% if ("curso".equals(est) || "entregado".equals(est)) { %>
                                                <button type="button" class="btn btn-secondary btn-sm py-1 px-2"
                                                        onclick="window.location.href='controladorpedido?accion=comprobante&id=<%=p.getId_pedido()%>'">
                                                    <i class="fa-solid fa-download fa-sm"></i>
                                                </button>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="8" class="text-center text-muted py-4">
                                            No se encontraron pedidos registrados.
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>

                        <div id="sinResultadosPedidos" class="sin-resultados">
                            No se encontraron pedidos con los filtros aplicados.
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal detalle -->
            <div class="modal fade" id="modalDetallePedido" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalLabel">Detalles del Pedido</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body" id="modalDetalleBody"></div>
                    </div>
                </div>
            </div>
        </main>

        <script>
            function abrirDetalle(idPedido) {
                const modalBody = document.getElementById('modalDetalleBody');
                modalBody.innerHTML = '<div class="text-center p-3">Cargando...</div>';

                const myModal = new bootstrap.Modal(document.getElementById('modalDetallePedido'));
                myModal.show();

                fetch('controladorpedido?accion=detalle&id=' + idPedido)
                    .then(response => response.text())
                    .then(html => {
                        modalBody.innerHTML = html;
                    })
                    .catch(err => {
                        modalBody.innerHTML = '<p class="text-danger">Error al cargar el detalle.</p>';
                    });
            }

            document.addEventListener("DOMContentLoaded", function () {
                const buscador = document.getElementById("buscarPedidoPerfil");
                const filtroEstado = document.getElementById("filtroEstadoPedidoPerfil");
                const orden = document.getElementById("ordenPedidoPerfil");
                const tbody = document.getElementById("tbodyPedidosPerfil");
                const aviso = document.getElementById("sinResultadosPedidos");

                if (!tbody) return;

                function obtenerFilasReales() {
                    return Array.from(tbody.querySelectorAll("tr")).filter(fila => fila.querySelector("td"));
                }

                function aplicarFiltros() {
                    const texto = buscador.value.trim().toLowerCase();
                    const estadoFiltro = filtroEstado.value.toLowerCase();
                    const filas = obtenerFilasReales();

                    let visibles = 0;

                    filas.forEach(fila => {
                        const id = fila.dataset.id || "";
                        const direccion = fila.dataset.direccion || "";
                        const delivery = fila.dataset.delivery || "";
                        const tipo = fila.dataset.tipo || "";
                        const pago = fila.dataset.pago || "";
                        const estado = fila.dataset.estado || "";

                        const textoFila = (id + " " + direccion + " " + delivery + " " + tipo + " " + pago + " " + estado).toLowerCase();

                        const cumpleBusqueda = texto === "" || textoFila.includes(texto);
                        const cumpleEstado = estadoFiltro === "" || estado === estadoFiltro;

                        if (cumpleBusqueda && cumpleEstado) {
                            fila.style.display = "";
                            visibles++;
                        } else {
                            fila.style.display = "none";
                        }
                    });

                    aviso.style.display = visibles === 0 ? "block" : "none";
                }

                function ordenarFilas() {
                    const tipoOrden = orden.value;
                    let filas = obtenerFilasReales();

                    filas.sort((a, b) => {
                        const idA = parseInt(a.dataset.id || "0");
                        const idB = parseInt(b.dataset.id || "0");
                        const estadoA = (a.dataset.estado || "").toLowerCase();
                        const estadoB = (b.dataset.estado || "").toLowerCase();
                        const tipoA = (a.dataset.tipo || "").toLowerCase();
                        const tipoB = (b.dataset.tipo || "").toLowerCase();
                        const pagoA = (a.dataset.pago || "").toLowerCase();
                        const pagoB = (b.dataset.pago || "").toLowerCase();

                        switch (tipoOrden) {
                            case "reciente":
                                return idB - idA;
                            case "antiguo":
                                return idA - idB;
                            case "estadoAZ":
                                return estadoA.localeCompare(estadoB);
                            case "estadoZA":
                                return estadoB.localeCompare(estadoA);
                            case "tipoAZ":
                                return tipoA.localeCompare(tipoB);
                            case "pagoAZ":
                                return pagoA.localeCompare(pagoB);
                            default:
                                return 0;
                        }
                    });

                    filas.forEach(fila => tbody.appendChild(fila));
                    aplicarFiltros();
                }

                buscador.addEventListener("input", aplicarFiltros);
                filtroEstado.addEventListener("change", aplicarFiltros);
                orden.addEventListener("change", ordenarFilas);

                ordenarFilas();
            });
        </script>
  
        <!-- Bootstrap y alertify -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <jsp:include page="/componentes/pie.jsp" />
        <jsp:include page="/componentes/mensajes.jsp" />
              <!-- LUEGO tu script del gráfico -->
        <script>
            document.addEventListener("DOMContentLoaded", function () {

                const productos = [
                    <c:forEach var="prod" items="${productosTopCliente}" varStatus="st">
                        "<c:out value='${prod}'/>"<c:if test="${!st.last}">,</c:if>
                    </c:forEach>
                ];

                const cantidades = [
                    <c:forEach var="cant" items="${cantidadesTopCliente}" varStatus="st">
                        ${cant}<c:if test="${!st.last}">,</c:if>
                    </c:forEach>
                ];

                console.log("Productos:", productos);
                console.log("Cantidades:", cantidades);

                const canvas = document.getElementById("graficoProductosCliente");
                if (!canvas) return;

                if (productos.length > 0 && cantidades.length > 0) {
                    new Chart(canvas, {
                        type: 'bar',
                        data: {
                            labels: productos,
                            datasets: [{
                                label: 'Cantidad solicitada',
                                data: cantidades,
                                backgroundColor: [
                                    '#F2DFDD',
                                    '#D8C3A5',
                                    '#C8A27A',
                                    '#B08968',
                                    '#EAD7D1'
                                ],
                                borderColor: '#7c6753',
                                borderWidth: 1,
                                borderRadius: 8,
                                maxBarThickness: 42
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    display: false
                                },
                                tooltip: {
                                    backgroundColor: '#7c6753',
                                    titleColor: '#fff',
                                    bodyColor: '#fff'
                                }
                            },
                            scales: {
                                x: {
                                    ticks: {
                                        color: '#7c6753',
                                        font: {
                                            size: 11
                                        }
                                    },
                                    grid: {
                                        display: false
                                    }
                                },
                                y: {
                                    beginAtZero: true,
                                    ticks: {
                                        stepSize: 1,
                                        color: '#7c6753'
                                    },
                                    grid: {
                                        color: '#f2dfdd'
                                    }
                                }
                            }
                        }
                    });
                } else {
                    console.log("No hay datos para el gráfico");
                }
            });
        </script>
    </body>
</html>