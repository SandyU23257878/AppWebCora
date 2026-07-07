<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.pedido"%>
<%@page import="java.util.List"%>
<%@page import="modelo.usuarios"%>
<%@page import="modelo.productos"%>

<%
List<usuarios> listaClientes = (List<usuarios>) request.getAttribute("clientes");
List<productos> listaVariantes =(List<productos>) request.getAttribute("variantes");
%>
<%
    List<modelo.pedido> lista = (List<pedido>) request.getAttribute("listaPedidos");
    int totalPedidos = 0;
    int pendientes = 0;
    int encurso = 0;
    int entregadas = 0;
    int cancelados = 0;
    
    if (lista != null) {
        totalPedidos = lista.size();
        for (pedido p : lista) {
            String est = (p.getEstado() != null) ? p.getEstado().toLowerCase() : "";
            if (est.equals("pendiente")) {
                pendientes++;
            } else if (est.equals("curso")) {
                encurso++;
            } else if (est.equals("entregado")) {
                entregadas++;
            } else if (est.equals("cancelado")) {
                cancelados++;
            }
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gestion Pedidos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Luxurious+Roman&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link class="rounded-circle" rel="icon" href="recursos/logo_cora.png">
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/alertify.min.css"/>
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/themes/default.min.css"/>

        <link rel="stylesheet" href="estilos/estilosa.css">
        <link rel="stylesheet" href="estilos/piestilo.css">
        <!-- html2pdf.js library -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    </head>
    <body>
        <%
            request.setAttribute("paginaActual", "pedidos");
        %>
        <jsp:include page="../componentes/encabezado.jsp" />
        <main class="container mt-5 pt-4" style="margin-top: 180px; margin-bottom: 150px;"> 
            <h2 class="mb-5 text-center">Listado de Pedidos</h2>
            
            <div class="card p-4 border-top-0 rounded-bottom mb-5" style="box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);">
                <div class="row g-2 align-items-center justify-content-between">

                    <!-- Buscador -->
                    <div class="col-12 col-md-3">
                        <form action="controladorpagina" method="GET" class="m-0">
                            <input type="hidden" name="pagina" value="lupa">
                            <div class="input-group">
                                <input id="buscarPedido" class="form-control border-end-0" type="search"  placeholder="Buscar por cliente o pedido..." >
                                <span class="input-group-text border-start-0 bg-white">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                </span>
                            </div>
                        </form>
                    </div>

                    <!-- Botones de Acción -->
                    <div class="col-12 col-md-4 d-flex gap-2">
                        <button class="btn btn-outline-primary px-3 text-nowrap" data-bs-toggle="modal" data-bs-target="#modalPDF">
                            <i class="fa-solid fa-download me-2"></i>Descargar PDF
                        </button>
                    </div>

                    <!-- Contadores alineados a la derecha -->
                    <div class="col-12 col-md-5">
                        <div class="d-flex gap-2 justify-content-start justify-content-md-end flex-wrap flex-md-nowrap">

                            <div class="text-center rounded border bg-light shadow-sm p-1" style="width: 85px;">
                                <small class="text-muted d-block text-truncate fw-semibold" style="font-size: 0.72rem;">Total</small>
                                <span class="fs-5 fw-bold text-dark"><%= totalPedidos %></span>
                            </div>

                            <div class="text-center rounded border bg-warning-subtle shadow-sm p-1" style="width: 85px;">
                                <small class="text-warning-emphasis d-block text-truncate fw-semibold" style="font-size: 0.72rem;">Pend.</small>
                                <span class="fs-5 fw-bold text-warning-emphasis"><%= pendientes %></span>
                            </div>

                            <div class="text-center rounded border bg-primary-subtle shadow-sm p-1" style="width: 85px;">
                                <small class="text-primary d-block text-truncate fw-semibold" style="font-size: 0.72rem;">Curso</small>
                                <span class="fs-5 fw-bold text-primary"><%= encurso %></span>
                            </div>

                            <div class="text-center rounded border bg-success-subtle shadow-sm p-1" style="width: 85px;">
                                <small class="text-success d-block text-truncate fw-semibold" style="font-size: 0.72rem;">Entregado</small>
                                <span class="fs-5 fw-bold text-success"><%= entregadas %></span>
                            </div>

                            <div class="text-center rounded border bg-danger-subtle shadow-sm p-1" style="width: 85px;">
                                <small class="text-danger d-block text-truncate fw-semibold" style="font-size: 0.72rem;">Cancelado</small>
                                <span class="fs-5 fw-bold text-danger"><%= cancelados %></span>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
            <div class="card shadow-sm p-4 mb-5">
                <div class="card-body">
                    <h4 class="mb-4 mt-4">Tabla pedidos</h4>
                    <div class="table-responsive">
                    <table class="table table-hover table-bordered">
                        <thead class="text-center" style="--bs-table-bg: #F5ECE1;">
                            <tr>
                                <th>Id Pedido</th>
                                <th>Cliente</th>
                                <th>Fecha</th>
                                <th>Entrega</th>
                                <th>Delivery</th>
                                <th>Dirección</th>
                                <th>Método Pago</th>
                                <th>Estado</th>
                                <th>Acciones</th>                                    

                            </tr>
                        </thead>
                        <tbody>
                            
                            <%
                                if (lista != null && !lista.isEmpty()) {
                                    for (pedido p : lista) {
                            %>
                            <tr class="align-middle filaPedido">
                                
                                <th scope="row" class="text-center">
                                    <%=p.getId_pedido()%>
                                </th>

                                <td><%=p.getNombreCompleto()%></td>

                                <td><%=p.getFecha_pedido()%></td>
                                <td style="text-transform: capitalize;"><%=p.getTipo_entrega()%></td>
                                <%
                                    String mensaje = "";
                                    double monto = p.getCosto_delivery();

                                    if ("fisico".equalsIgnoreCase(p.getTipo_entrega())) {
                                        mensaje = "<span class='text-muted'>No aplica</span>";
                                    } else {
                                        if (monto <= 0) {
                                            mensaje = "<span class='text-danger'>Por definirse</span>";
                                        } else {
                                            mensaje = "S/. " + String.format("%.2f", monto);
                                        }
                                    }
                                %>
                                <td><%= mensaje %></td>
                                <td style="text-transform: capitalize;"><%=p.getDireccion().toLowerCase()%></td>
                                <td style="text-transform: capitalize;"><%=p.getMetodo_pago()%></td>
                                <td>
                                    <%
                                        String est = (p.getEstado() != null) ? p.getEstado().toLowerCase() : "";
                                        String badgeClass = "text-secondary";

                                        if (est.equals("pendiente")) badgeClass = "text-warning fw-bold";
                                        else if (est.equals("curso")) badgeClass = "text-primary fw-bold";
                                        else if (est.equals("entregado")) badgeClass = "text-success fw-bold";
                                        else if (est.equals("cancelado")) badgeClass = "text-danger text-decoration-line-through text-muted";
                                    %>
                                    <span class="<%= badgeClass %>" style="text-transform: capitalize;"><%= est %></span>
                                </td>
                                <td class="text-center">
                                    <div class="d-flex flex-wrap justify-content-center gap-1">

                                        <% if(!"cancelado".equalsIgnoreCase(p.getEstado())) { %>
                                            <button class="btn btn-danger btn-sm btn-action"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#modalAnular<%=p.getId_pedido()%>">
                                                <i class="fa-solid fa-ban"></i>
                                            </button>

                                            <button type="button"
                                                    class="btn btn-actualizar btn-sm btn-action"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#modalEstado<%=p.getId_pedido()%>">
                                                <i class="fa-solid fa-arrows-rotate"></i>
                                            </button>
                                        <% } %>

                                        <%-- BOTÓN EDITAR DELIVERY SOLO SI ES DELIVERY Y NO ESTÁ CANCELADO --%>
                                        <% if("delivery".equalsIgnoreCase(p.getTipo_entrega()) && !"cancelado".equalsIgnoreCase(p.getEstado())) { %>
                                            <button type="button"
                                                    class="btn btn-warning btn-sm btn-action"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#modalDelivery<%=p.getId_pedido()%>"
                                                    title="Editar costo de delivery">
                                                <i class="fa-solid fa-truck-fast"></i>
                                            </button>
                                        <% } %>

                                        <% if(!"cancelado".equalsIgnoreCase(p.getEstado()) && !"pendiente".equalsIgnoreCase(p.getEstado())) { %>
                                            <a href="controladorpedido?accion=comprobante&id=<%=p.getId_pedido()%>"
                                               class="btn btn-outline-primary btn-sm btn-action">
                                                <i class="fa-solid fa-download"></i>
                                            </a>
                                        <% } %>

                                        <a class="btn btn-info btn-sm btn-action"
                                           href="controladorpedido?accion=detalle&id=<%=p.getId_pedido()%>">
                                            <i class="fa-solid fa-eye"></i>
                                        </a>

                                    </div>
                                </td>

                            </tr>
                            <% if("delivery".equalsIgnoreCase(p.getTipo_entrega()) && !"cancelado".equalsIgnoreCase(p.getEstado())) { %>
                            <div class="modal fade" id="modalDelivery<%=p.getId_pedido()%>" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered">
                                    <div class="modal-content border-0 shadow-lg">

                                        <form action="controladorpedido" method="post">
                                            <input type="hidden" name="accion" value="actualizarDelivery">
                                            <input type="hidden" name="idPedido" value="<%=p.getId_pedido()%>">

                                            <div class="modal-header border-bottom-0">
                                                <h5 class="modal-title fw-bold" style="color:#a86c3d;">
                                                    <i class="fa-solid fa-truck-fast me-2"></i>Actualizar costo de delivery
                                                </h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>

                                            <div class="modal-body">
                                                <div class="mb-3">
                                                    <label class="form-label fw-semibold">Pedido</label>
                                                    <input type="text" class="form-control bg-light" value="#<%=p.getId_pedido()%>" readonly>
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label fw-semibold">Cliente</label>
                                                    <input type="text" class="form-control bg-light" value="<%=p.getNombreCompleto()%>" readonly>
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label fw-semibold">Tipo de entrega</label>
                                                    <input type="text" class="form-control bg-light" value="<%=p.getTipo_entrega()%>" readonly>
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label fw-semibold">Costo actual de delivery</label>
                                                    <input type="number"
                                                           step="0.01"
                                                           min="0"
                                                           name="costoDelivery"
                                                           class="form-control"
                                                           value="<%=p.getCosto_delivery()%>"
                                                           required>
                                                    <small class="text-muted">Puedes aumentar o disminuir el monto según corresponda.</small>
                                                </div>
                                            </div>

                                            <div class="modal-footer border-top-0 bg-light">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                <button type="submit" class="btn btn-warning text-dark fw-semibold">
                                                    Guardar delivery
                                                </button>
                                            </div>
                                        </form>

                                    </div>
                                </div>
                            </div>
                            <% } %>
                            <div class="modal fade" id="modalEstado<%=p.getId_pedido()%>">
                                <div class="modal-dialog modal-dialog-centered">
                                    <div class="modal-content border-0 shadow-lg">
                                         <form action="controladorpedido" method="post" onsubmit="return validarFechasCambioEstado(this)">
                                              <input type="hidden" name="accion" value="cambiarEstado">
                                            <input type="hidden" name="id" value="<%=p.getId_pedido()%>">

                                            <div class="modal-header border-bottom-0">
                                                <h5 class="fw-bold text-secondary" style="color: #727CBB !important;"><i class="fa-solid fa-arrows-rotate me-2"></i>Actualizar Estado</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>

                                            <div class="modal-body py-4">
                                                <p class="text-muted small mb-4 text-center">Selecciona la etapa actual para el pedido <strong>#<%=p.getId_pedido()%></strong></p>

                                                <div class="d-flex justify-content-between align-items-center position-relative px-2 cora-flow-container">

                                                    <div class="position-absolute top-50 start-0 end-0 translate-y-50 bg-light-subtle cora-flow-progress-line"></div>

                                                    <div class="text-center position-relative item-flow" style="z-index: 2; flex: 1;">
                                                        <input type="radio" class="btn-check estado-radio" name="estado" data-pedido="<%=p.getId_pedido()%>" value="pendiente" id="statusPend<%=p.getId_pedido()%>" <%= "pendiente".equalsIgnoreCase(p.getEstado()) ? "checked" : "" %>>
                                                        <label class="btn cora-btn-status d-flex flex-column align-items-center justify-content-center mx-auto shadow-sm cora-state-pending" for="statusPend<%=p.getId_pedido()%>">
                                                            <span class="cora-badge-step mb-2">1</span>
                                                            <i class="fa-solid fa-clock fs-4 mb-2"></i>
                                                            <span class="fw-semibold small">Pendiente</span>
                                                        </label>
                                                    </div>

                                                    <div class="text-center position-relative item-flow" style="z-index: 2; flex: 1;">
                                                        <input type="radio" class="btn-check estado-radio" name="estado" data-pedido="<%=p.getId_pedido()%>" value="curso" id="statusCurs<%=p.getId_pedido()%>" <%= "curso".equalsIgnoreCase(p.getEstado()) ? "checked" : "" %>>
                                                        <label class="btn cora-btn-status d-flex flex-column align-items-center justify-content-center mx-auto shadow-sm cora-state-progress" for="statusCurs<%=p.getId_pedido()%>">
                                                            <span class="cora-badge-step mb-2">2</span>
                                                            <i class="fa-solid fa-spinner fs-4 mb-2"></i>
                                                            <span class="fw-semibold small">En Curso</span>
                                                        </label>
                                                    </div>

                                                    <div class="text-center position-relative item-flow" style="z-index: 2; flex: 1;">
                                                        <input type="radio" class="btn-check estado-radio" name="estado" value="entregado" data-pedido="<%=p.getId_pedido()%>" id="statusEntr<%=p.getId_pedido()%>" <%= "entregado".equalsIgnoreCase(p.getEstado()) ? "checked" : "" %>>
                                                        <label class="btn cora-btn-status d-flex flex-column align-items-center justify-content-center mx-auto shadow-sm cora-state-delivered" for="statusEntr<%=p.getId_pedido()%>">
                                                            <span class="cora-badge-step mb-2">3</span>
                                                            <i class="fa-solid fa-box-open fs-4 mb-2"></i>
                                                            <span class="fw-semibold small">Entregado</span>
                                                        </label>
                                                    </div>
                                                    
                                                </div>
                                                <div class="row mt-4 bloqueFechas"
                                                    id="bloqueFechas<%=p.getId_pedido()%>"
                                                    style="<%= ("curso".equalsIgnoreCase(p.getEstado()) || "entregado".equalsIgnoreCase(p.getEstado())) ? "" : "display:none;" %>">

                                                   <div class="col-md-6">
                                                       <label class="form-label">Fecha mínima estimada</label>

                                                       <input type="date" name="fechaMin" class="form-control" value="<%= p.getFechaEntregaMin() != null ? p.getFechaEntregaMin().toString() : "" %>">
                                                   </div>

                                                   <div class="col-md-6">
                                                       <label class="form-label">Fecha máxima estimada</label>

                                                       <input type="date" name="fechaMax"  class="form-control" value="<%= p.getFechaEntregaMax() != null ? p.getFechaEntregaMax().toString() : "" %>">
                                                   </div>

                                               </div>      
                                            </div>

                                            <div class="modal-footer border-top-0 bg-light-subtle rounded-bottom">
                                                <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal">Cerrar</button>
                                                <button class="btn btn-primary px-4 shadow-sm" style="background-color: #5a67d8; border-color: #5a67d8;">
                                                    Actualizar Cambios
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <div class="modal fade" id="modalAnular<%=p.getId_pedido()%>">

                                <div class="modal-dialog modal-dialog-centered">

                                    <div class="modal-content">

                                        <div class="modal-header">
                                            <h5>Confirmar anulación</h5>
                                        </div>

                                        <div class="modal-body">
                                            <div class="alert alert-warning">

                                                <strong>¿Está seguro?</strong><br>

                                                Esta acción es irreversible.

                                                El pedido será cancelado y el stock será restaurado automáticamente.

                                            </div>
                                            ¿Desea anular el pedido
                                            #<%=p.getId_pedido()%>?

                                        </div>

                                        <div class="modal-footer">

                                            <button class="btn btn-secondary" data-bs-dismiss="modal">
                                                Cancelar
                                            </button>

                                            <a href="controladorpedido?accion=anular&id=<%=p.getId_pedido()%>"  class="btn btn-danger">

                                                Anular pedido

                                            </a>

                                        </div>

                                    </div>

                                </div>

                            </div>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="9" class="text-center text-muted">No se encontraron pedidos registrados.</td>
                            </tr>
                            <%
                                }
                            %>
                            <tr id="sinResultados" style="display:none;">
                                <td colspan="9" class="text-center text-muted p-4">
                                    No se encontraron pedidos que coincidan con la búsqueda.
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </div>
                </div>
            </div>                
            <div class="card shadow-sm mb-5 ">
                <div class="card-header bg-white py-3">
                    <h4 class="mb-4 mt-4 text-center">Generar pedidos</h4>
                </div>
                <div class="card-body p-4">
                    <form id="formInsertarPedido" action="controladorpedido" method="POST">
                        <input type="hidden" name="accion" value="guardarAdmin">
                        <input type="hidden" name="carrito" id="carritoInput">

                        <div class="row g-3 px-4">
                            <div class="col-md-6 border-end pe-md-4">
                                <h6 class="text-primary mb-3 border-bottom pb-2" style="color: #BF746E !important;">
                                    <i class="fa-solid fa-user me-2"></i>Datos de Entrega
                                </h6>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Nombre de cliente</label>
                                    <select name="idUsuario" class="form-select" required>
                                        <option value="" selected disabled>Seleccionar cliente</option>
                                        <% if (listaClientes != null) {
                                            for (usuarios c : listaClientes) { %>
                                                <option value="<%= c.getIdUsuario()%>">(ID: <%= c.getIdUsuario()%>) - <%= c.getNombrecompleto()%></option>
                                        <%   }
                                        } %>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Tipo de entrega</label>
                                    <select name="tipoEntrega" id="tipoEntrega" class="form-select">
                                        <option value="delivery">Delivery</option>
                                        <option value="fisico">Fisico(tienda)</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Costo de delivery</label>
                                    <input type="number" step="0.01" class="form-control" name="costoDelivery" id="costoDelivery" value="0">                     
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Dirección</label>
                                    <input type="text" class="form-control" name="direccion" id="direccion" placeholder="Ej: Av. Central 123" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Método de pago</label>
                                    <select name="metodoPago" class="form-select">
                                        <option value="tarjeta">Tarjeta</option>
                                        <option value="efectivo">Efectivo</option>
                                        <option value="yape">Yape</option>
                                    </select>
                                </div>
                            </div>

                            <div class="col-md-6 ps-md-4">
                                <h6 class="text-primary mb-3 border-bottom pb-2" style="color: #BF746E !important;">
                                    <i class="fa-solid fa-box me-2"></i>Detalles del Producto
                                </h6>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Producto</label>
                                    <select id="selectProducto" class="form-select" >
                                        <option value="">Seleccione producto</option>
                                        <% 
                                        java.util.HashSet<Integer> productosMostrados = new java.util.HashSet<>();
                                        if(listaVariantes != null){
                                            for(productos p : listaVariantes){
                                                if(!productosMostrados.contains(p.getId_producto())){
                                                    productosMostrados.add(p.getId_producto());
                                        %>
                                                    <option value="<%=p.getId_producto()%>"><%=p.getNombre_producto()%></option>
                                        <%
                                                }
                                            }
                                        }
                                        %>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Color</label>
                                    <select id="selectColor" class="form-select" disabled>
                                        <option>Seleccione producto</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Talla</label>
                                    <select id="selectTalla" name="idVariante" class="form-select" disabled>
                                        <option>Seleccione color</option>
                                    </select>
                                </div>

                                <div class="row g-2 mb-3">
                                    <div class="col-6">
                                        <label class="form-label fw-semibold">Stock disponible</label>
                                        <input type="text" id="stockDisponible" class="form-control bg-light" readonly>
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label fw-semibold">Precio unitario</label>
                                        <input type="text" id="precioUnitario" class="form-control bg-light" readonly>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Cantidad</label>
                                    <input type="number" id="cantidad" name="cantidad" class="form-control" min="1" value="1" required>
                                </div>

                                <div class="mb-3">
                                    <button type="button" class="btn btn-success w-100" onclick="agregarAlCarrito()">
                                        Agregar producto
                                    </button>
                                </div>

                                <table class="table table-sm mt-3">
                                    <thead>
                                        <tr>
                                            <th>Producto</th>
                                            <th>Talla</th>
                                            <th>Cant</th>
                                            <th>Precio</th>
                                            <th>Subtotal</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tablaCarrito" ></tbody>
                                </table>    

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Total a Pagar</label>
                                    <input type="text" id="totalPedido" class="form-control fw-bold text-success bg-light fs-5" readonly>
                                </div>

                                <div class="card bg-light border-start border-primary border-3 shadow-sm mt-4" style="border-color: #e5b9b5 !important;">
                                    <div class="card-body p-3">
                                        <h6 class="card-title fw-bold text-secondary mb-2" style="color: #a68b6d !important;">
                                            <i class="fa-solid fa-receipt me-2"></i>Resumen rápido
                                        </h6>
                                        <div class="d-flex justify-content-between small mb-1">
                                            <span>Productos:</span>
                                            <span id="txtItems" class="fw-bold">0</span>
                                        </div>
                                        <div class="d-flex justify-content-between small mb-1">
                                            <span>Delivery:</span>
                                            <span>S/ <span id="txtDelivery">0.00</span></span>
                                        </div>
                                        <hr class="my-2">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span class="fw-bold">Total General:</span>
                                            <span class="text-primary fw-bold fs-5" style="color: #D63384 !important;">S/ <span id="txtTotal">0.00</span></span>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </form>
                </div>

                <div class="card-footer bg-light d-flex justify-content-end gap-2 py-3">
                    <button type="submit" form="formInsertarPedido" class="btn btn-primary px-4" style="background-color: #5a67d8; border-color: #5a67d8;">
                        Guardar Pedido
                    </button>
                </div>
            </div>
            
                                            
                                       
        </main>

        <!-- Modal para exportar PDF -->
        <div class="modal fade" id="modalPDF" tabindex="-1" aria-labelledby="modalPDFLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg">
                    <div class="modal-header bg-light border-bottom-0">
                        <h5 class="modal-title fw-bold text-secondary" id="modalPDFLabel">
                            <i class="fa-solid fa-file-pdf text-danger me-2"></i>Exportar Reporte de Pedidos
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body py-4 text-start">
                        <p class="text-muted text-center mb-4">Seleccione la modalidad de reporte que desea descargar.</p>
                        <div class="d-grid gap-3">
                            <button class="btn btn-outline-primary text-start p-3 rounded-3" onclick="exportarPedidosPDF('visible')">
                                <i class="fa-solid fa-list-check me-2 fs-5"></i>
                                <strong>Reporte de pedidos filtrados / visibles</strong>
                                <div class="small text-muted mt-1">Exporta únicamente los pedidos que se muestran actualmente en pantalla.</div>
                            </button>
                            <button class="btn btn-outline-secondary text-start p-3 rounded-3" onclick="exportarPedidosPDF('completo')">
                                <i class="fa-solid fa-database me-2 fs-5"></i>
                                <strong>Reporte completo de todos los pedidos</strong>
                                <div class="small text-muted mt-1">Exporta la totalidad de los pedidos registrados en el sistema.</div>
                            </button>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0 bg-light">
                        <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Cerrar</button>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/componentes/pie.jsp" /> 
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <jsp:include page="/componentes/alertas.jsp" />  

        <script>
        const variantes = [
        <%
        if(listaVariantes != null){
            for(int i=0;i<listaVariantes.size();i++){
                productos v = listaVariantes.get(i);
        %>
        {
            idVariante:<%=v.getId_variante()%>,
            idProducto:<%=v.getId_producto()%>,
            color:"<%=v.getColor()%>",
            talla:"<%=v.getTalla()%>",
            stock:<%=v.getStock()%>,
            precio:<%=v.getPrecio()%>
        }
        <%= (i < listaVariantes.size()-1) ? "," : "" %>
        <%
            }
        }
        %>
        ];
        
        const producto = document.getElementById("selectProducto");
        const color = document.getElementById("selectColor");
        const talla = document.getElementById("selectTalla");

        producto.addEventListener("change", () => {
            color.innerHTML = '<option value="">Seleccione color</option>';
            color.disabled = false;
            talla.innerHTML = '<option>Seleccione color</option>';
            talla.disabled = true;
            resetResumen();

            const colores = [
                ...new Set(
                    variantes
                        .filter(v => v.idProducto == producto.value)
                        .map(v => v.color)
                )
            ];

            colores.forEach(c => {
                let option = document.createElement("option");
                option.value = c;
                option.textContent = c;
                color.appendChild(option);
            });
        });

        color.addEventListener("change", () => {
            talla.innerHTML = '<option value="">Seleccione talla</option>';
            talla.disabled = false;
            resetResumen();

            variantes
                .filter(v =>
                    v.idProducto == producto.value &&
                    v.color == color.value
                )
                .forEach(v => {
                    let option = document.createElement("option");
                    option.value = v.idVariante;
                    option.textContent = v.talla;
                    option.dataset.stock = v.stock;
                    option.dataset.precio = v.precio;
                    talla.appendChild(option);
                });
        });

        talla.addEventListener("change", () => {

            let opcion = talla.options[talla.selectedIndex];

            if(opcion.value !== ""){

                let stock = parseInt(opcion.dataset.stock);

                document.getElementById("cantidad").max = stock;

                document.getElementById("stockDisponible").value = stock;
                document.getElementById("precioUnitario").value =
                    parseFloat(opcion.dataset.precio).toFixed(2);

            }

            calcularTotal();
        });

        document.getElementById("cantidad").addEventListener("input", calcularTotal);
        document.getElementById("costoDelivery").addEventListener("input", calcularTotal);
        function calcularTotal(){
            let cantidad = parseInt(document.getElementById("cantidad").value) || 0;
            let precio = parseFloat(document.getElementById("precioUnitario").value) || 0;
            let deliveryInput = document.getElementById("costoDelivery");
            let delivery = deliveryInput.disabled ? 0 : (parseFloat(deliveryInput.value) || 0);;

            let subtotal = cantidad * precio;
            let total = subtotal + delivery;
            
            document.getElementById("txtDelivery").textContent = delivery.toFixed(2);
            document.getElementById("totalPedido").value = "S/ " + total.toFixed(2);
            document.getElementById("txtTotal").textContent = total.toFixed(2);
        }

        function resetResumen() {
            
            document.getElementById("stockDisponible").value = "";
            document.getElementById("precioUnitario").value = "";
            let tipo = document.getElementById("tipoEntrega").value;
            document.getElementById("costoDelivery").disabled = (tipo === "fisico");
            document.getElementById("txtDelivery").textContent = "0.00";
            document.getElementById("costoDelivery").value = "0";
            document.getElementById("txtTotal").textContent = "0.00";
            document.getElementById("totalPedido").value = "";
        }
        document.getElementById("tipoEntrega").addEventListener("change", function () {

            let deliveryInput = document.getElementById("costoDelivery");
            let direccionInput = document.getElementById("direccion");

            if (this.value === "fisico") {

                deliveryInput.value = 0;
                deliveryInput.disabled = true;

                document.getElementById("txtDelivery").textContent = "0.00";

                direccionInput.value = "LARCOMAR, tienda 220, Lima, Peru";
                direccionInput.readOnly = true;

            } else {

                deliveryInput.disabled = false;

                direccionInput.value = "";
                direccionInput.readOnly = false;
            }

            calcularTotalGeneral();
        });
        let carrito = [];

        
        function agregarAlCarrito() {

            let idProducto = document.getElementById("selectProducto").value;
            let colorSeleccionado = document.getElementById("selectColor").value;
            let idVariante = document.getElementById("selectTalla").value;
            let cantidad = parseInt(document.getElementById("cantidad").value);

            if(!idProducto){
                alertify.error("Seleccione un producto");
                return;
            }

            if(!colorSeleccionado){
                alertify.error("Seleccione un color");
                return;
            }

            if(!idVariante){
                alertify.error("Seleccione una talla");
                return;
            }

            if(!cantidad || cantidad <= 0){
                alertify.error("Ingrese una cantidad válida");
                return;
            }
            
            let opcion = document.getElementById("selectTalla").selectedOptions[0];
            let stock = parseInt(opcion.dataset.stock);

            if(cantidad > stock){
                alertify.error("La cantidad supera el stock disponible");
                return;
            }
            let item = {
                idVariante: idVariante,
                idProducto: idProducto,
                nombre: producto.selectedOptions[0].text,
                talla: opcion.text,
                color: colorSeleccionado,
                precio: parseFloat(opcion.dataset.precio),
                cantidad: cantidad
            };
            let existente = carrito.find(i =>
                i.idVariante === item.idVariante
            );
            if(existente){

                let nuevaCantidad =
                    existente.cantidad + item.cantidad;

                if(nuevaCantidad > stock){
                    alertify.error(
                        "La cantidad total supera el stock"
                    );
                    return;
                }

                existente.cantidad = nuevaCantidad;

            }else{

                carrito.push(item);

            }

            renderCarrito();

            document.getElementById("cantidad").value = 1;
            document.getElementById("selectProducto").selectedIndex = 0;

            document.getElementById("selectColor").innerHTML = "<option>Seleccione producto</option>";
            document.getElementById("selectColor").disabled = true;

            document.getElementById("selectTalla").innerHTML = "<option>Seleccione color</option>";
            document.getElementById("selectTalla").disabled = true;
            limpiarSeleccionProducto();
        }
        
        function renderCarrito() {

            let tbody = document.getElementById("tablaCarrito");
            tbody.innerHTML = "";

            carrito.forEach((item, index) => {

                console.log("ITEM COMPLETO:", item);

                tbody.innerHTML +=
                    "<tr>" +
                    "<td>" + item.nombre + "</td>" +
                    "<td>" + item.talla + "</td>" +
                    "<td>" + item.cantidad + "</td>" +
                    "<td>S/ " + item.precio.toFixed(2) + "</td>" +
                    "<td>S/ " + (item.precio * item.cantidad).toFixed(2) + "</td>" +
                    "<td>" +
                        "<div class='d-flex flex-column flex-md-row gap-1 justify-content-center'>" +
                            "<button type='button' class='btn btn-warning btn-sm w-100 w-md-auto' onclick='editarItem(" + index + ")'>" +
                                "<i class='fa-solid fa-pen'></i>" +
                            "</button>" +
                            "<button type='button' class='btn btn-danger btn-sm w-100 w-md-auto' onclick='eliminarItem(" + index + ")'>" +
                                "<i class='fa-solid fa-trash-can'></i>" +
                            "</button>" +
                        "</div>" +
                    "</td>" +
                    "</tr>";
            });

            calcularTotalGeneral();
        }
        function eliminarItem(index){
            carrito.splice(index,1);

            if(carrito.length === 0){
                limpiarSeleccionProducto();
                resetResumen();
            }

            renderCarrito();
        }
        function calcularTotalGeneral(){

            let total = 0;

            carrito.forEach(i => {
                total += i.precio * i.cantidad;
            });

            let deliveryInput = document.getElementById("costoDelivery");

            let delivery =
                deliveryInput.disabled
                ? 0
                : (parseFloat(deliveryInput.value) || 0);

            total += delivery;

            document.getElementById("txtDelivery").textContent =  delivery.toFixed(2);
            document.getElementById("txtItems").textContent = carrito.length;
            document.getElementById("txtTotal").textContent = total.toFixed(2);

            document.getElementById("totalPedido").value = "S/ " + total.toFixed(2);
        }

        document.getElementById("formInsertarPedido")
        .addEventListener("submit", function(e){

            if(carrito.length === 0){
                e.preventDefault();
                alert("Debe agregar al menos un producto");
                return;
            }

            document.getElementById("carritoInput").value = JSON.stringify(carrito);
        });
        function editarItem(index){

            let item = carrito[index];

            document.getElementById("selectProducto").value =
                item.idProducto;

            producto.dispatchEvent(new Event("change"));

            setTimeout(() => {

                document.getElementById("selectColor").value =
                    item.color;

                color.dispatchEvent(new Event("change"));

                setTimeout(() => {

                    document.getElementById("selectTalla").value =
                        item.idVariante;

                    talla.dispatchEvent(new Event("change"));

                    document.getElementById("cantidad").value =
                        item.cantidad;

                }, 50);

            }, 50);

            carrito.splice(index,1);

            renderCarrito();

            alertify.message("Producto cargado para edición");
        }
        function limpiarSeleccionProducto(){
            document.getElementById("cantidad").value = 1;
            document.getElementById("selectProducto").selectedIndex = 0;

            document.getElementById("selectColor").innerHTML = "<option>Seleccione producto</option>";
            document.getElementById("selectColor").disabled = true;

            document.getElementById("selectTalla").innerHTML = "<option>Seleccione color</option>";
            document.getElementById("selectTalla").disabled = true;

            document.getElementById("stockDisponible").value = "";
            document.getElementById("precioUnitario").value = "";
        }
        
        document.getElementById("buscarPedido").addEventListener("keyup", function () {

            let texto = this.value.toLowerCase();

            let filas = document.querySelectorAll(".filaPedido");

            let encontrados = 0;

            filas.forEach(fila => {

                let cliente = fila.cells[1].textContent.toLowerCase();
                let idPedido = fila.cells[0].textContent.toLowerCase();

                if (
                    cliente.includes(texto) ||
                    idPedido.includes(texto)
                ) {
                    fila.style.display = "";
                    encontrados++;
                } else {
                    fila.style.display = "none";
                }

            });

            document.getElementById("sinResultados").style.display =
                encontrados === 0 ? "" : "none";
        });

        document.querySelectorAll(".estado-radio").forEach(radio => {

            radio.addEventListener("change", function () {

                let idPedido = this.dataset.pedido;

                let bloque =
                    document.getElementById(
                        "bloqueFechas" + idPedido
                    );

                if (
                    this.value === "curso" ||
                    this.value === "entregado"
                ) {

                    bloque.style.display = "";

                } else {

                    bloque.style.display = "none";

                }

            });

        });

        function validarFechasCambioEstado(form) {
            const estadoRadio = form.querySelector('input[name="estado"]:checked');
            if (!estadoRadio) return true;
            
            const estado = estadoRadio.value;
            if (estado === 'curso' || estado === 'entregado') {
                const fMinInput = form.querySelector('input[name="fechaMin"]');
                const fMaxInput = form.querySelector('input[name="fechaMax"]');
                if (!fMinInput || !fMaxInput) return true;
                
                const fMin = fMinInput.value;
                const fMax = fMaxInput.value;
                
                if (!fMin || !fMax) {
                    alertify.error("Las fechas de entrega son obligatorias para el estado 'En curso' o 'Entregado'.");
                    return false;
                }
                
                const dateMin = new Date(fMin);
                const dateMax = new Date(fMax);
                dateMin.setHours(0,0,0,0);
                dateMax.setHours(0,0,0,0);
                
                if (dateMax <= dateMin) {
                    alertify.error("La fecha máxima de entrega debe ser posterior a la fecha mínima.");
                    return false;
                }
                
                const diffTime = Math.abs(dateMax - dateMin);
                const diffDays = Math.round(diffTime / (1000 * 60 * 60 * 24));
                
                if (diffDays !== 2) {
                    alertify.error("El intervalo de entrega estimado debe ser de exactamente 2 días.");
                    return false;
                }
            }
            return true;
        }

        function exportarPedidosPDF(tipo) {
            // Hide modal
            const modalEl = document.getElementById('modalPDF');
            const modalInstance = bootstrap.Modal.getInstance(modalEl);
            if (modalInstance) {
                modalInstance.hide();
            }
            
            // Create cloned container to format report
            const reportContainer = document.createElement('div');
            reportContainer.style.padding = '30px';
            reportContainer.style.fontFamily = 'Arial, sans-serif';
            
            // Add header
            const dateStr = new Date().toLocaleDateString('es-PE', {
                year: 'numeric', month: 'long', day: 'numeric',
                hour: '2-digit', minute: '2-digit'
            });
            
            reportContainer.innerHTML = `
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2" style="border-bottom: 2px solid #5a67d8;">
                    <div>
                        <h2 style="font-family: 'Luxurious Roman', serif; color: #AF2369; margin: 0;">CORA: Hecho a Mano</h2>
                        <h5 class="text-muted mt-1">Reporte de Gestión de Pedidos</h5>
                    </div>
                    <div class="text-end text-muted small">
                        <p class="m-0">Generado el: \${dateStr}</p>
                        <p class="m-0">Tipo: \${tipo === 'visible' ? 'Pedidos Filtrados' : 'Todos los Pedidos'}</p>
                    </div>
                </div>
            `;
            
            // Clone the table
            const originalTable = document.querySelector('table.table');
            if (!originalTable) {
                alertify.error("No se encontró la tabla de pedidos.");
                return;
            }
            
            const clonedTable = originalTable.cloneNode(true);
            clonedTable.className = "table table-striped table-bordered table-sm small align-middle";
            
            // Remove "Acciones" columns (the last column) from the cloned table
            const headerRow = clonedTable.querySelector('thead tr');
            if (headerRow) {
                headerRow.removeChild(headerRow.lastElementChild); // Remove 'Acciones' header
            }
            
            const bodyRows = clonedTable.querySelectorAll('tbody tr');
            bodyRows.forEach(row => {
                const isHidden = row.style.display === "none";
                if (tipo === 'visible' && isHidden) {
                    row.parentNode.removeChild(row);
                } else {
                    // Ensure the row is visible in the print view
                    row.style.display = "";
                    // Remove the last column (Acciones column)
                    if (row.lastElementChild) {
                        row.removeChild(row.lastElementChild);
                    }
                }
            });
            
            reportContainer.appendChild(clonedTable);
            
            const opt = {
                margin:       0.3,
                filename:     'Reporte_Pedidos_' + (tipo === 'visible' ? 'Filtrado' : 'Completo') + '.pdf',
                image:        { type: 'jpeg', quality: 0.98 },
                html2canvas:  { scale: 2, useCORS: true },
                jsPDF:        { unit: 'in', format: 'letter', orientation: 'landscape' }
            };
            
            html2pdf().from(reportContainer).set(opt).save();
        }
</script>
    </body>
</html>