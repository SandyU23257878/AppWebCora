<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.pedido, modelo.detallepedido, modelo.totalpedido, java.util.List"%>
<%
    pedido p = (pedido) request.getAttribute("pedido");
    totalpedido total = (totalpedido) request.getAttribute("totalPedido");
    List<detallepedido> detalles = (List<detallepedido>) request.getAttribute("detallePedido");
    
    if (p == null) {
        response.sendRedirect("controladorperfil");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pedido Realizado con Éxito</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Luxurious+Roman&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="icon" href="recursos/logo_cora.png">
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/alertify.min.css"/>
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/themes/default.min.css"/>

        <link rel="stylesheet" href="estilos/estilos.css">
        <link rel="stylesheet" href="estilos/piestilo.css">
        <style>
            .success-checkmark {
                width: 80px;
                height: 80px;
                margin: 0 auto 20px;
                background-color: #f2dfdd;
                color: #AF2369;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 2.5rem;
                box-shadow: 0 4px 10px rgba(175, 35, 105, 0.2);
                animation: scaleIn 0.5s ease-in-out;
            }
            @keyframes scaleIn {
                0% { transform: scale(0); }
                100% { transform: scale(1); }
            }
            .ticket-cuerpo table th {
                border-bottom: 2px solid #e5b9b5 !important;
                color: #7c6753;
            }
        </style>
        <!-- html2pdf.js library -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    </head>
    <body>
        <%
            request.setAttribute("paginaActual", "perfil");        
        %>
        <jsp:include page="/componentes/encabezado.jsp" />

        <main class="container mt-5 pt-4" style="margin-top: 180px; margin-bottom: 150px;"> 
            <div class="row justify-content-center">
                <div class="col-lg-8 text-center mb-4">
                    <div class="success-checkmark">
                        <i class="fa-solid fa-circle-check"></i>
                    </div>
                    <h2 class="subcora mb-2" style="font-family: 'Luxurious Roman', serif; font-size: 2.5rem;">¡Pedido Realizado con Éxito!</h2>
                    <p class="text-muted">Tu pedido ha sido registrado y está listo para ser procesado.</p>
                </div>
            </div>

            <div class="row justify-content-center">
                <div class="col-lg-7">
                    <!-- Ticket a exportar -->
                    <div class="card tarjeta-personalizada-cora shadow-sm p-4 mb-4" id="ticketComprobante">
                        <div class="ticket-contenedor-cora p-3">
                            <div class="text-center mb-4">
                                <h3 class="subcora m-0" style="font-family: 'Luxurious Roman', serif; color: #AF2369; font-weight: bold;">CORA: Hecho a Mano</h3>
                                <small class="text-muted">Ropa & Accesorios - Comprobante de Pedido</small>
                                <hr style="border-top: 1px dashed #d1c4b9;">
                            </div>

                            <div class="row mb-4 text-start">
                                <div class="col-sm-6 mb-2">
                                    <h6 class="fw-bold mb-1" style="color: #7c6753;">Detalles de Pedido:</h6>
                                    <p class="mb-0 small"><strong>Pedido:</strong> #<%= p.getId_pedido() %></p>
                                    <p class="mb-0 small"><strong>Fecha:</strong> <%= p.getFecha_pedido() %></p>
                                    <p class="mb-0 small"><strong>Estado:</strong> <span class="fw-bold text-warning-emphasis text-capitalize"><%= p.getEstado() %></span></p>
                                </div>
                                <div class="col-sm-6 mb-2">
                                    <h6 class="fw-bold mb-1" style="color: #7c6753;">Datos de Entrega:</h6>
                                    <p class="mb-0 small"><strong>Cliente:</strong> <%= p.getNombreCompleto() %></p>
                                    <p class="mb-0 small"><strong>Dirección:</strong> <%= p.getDireccion() %></p>
                                    <p class="mb-0 small"><strong>Tipo:</strong> <span class="text-capitalize"><%= p.getTipo_entrega() %></span></p>
                                </div>
                            </div>

                            <div class="row mb-3 text-start">
                                <div class="col-sm-6 mb-2">
                                    <h6 class="fw-bold mb-1" style="color: #7c6753;">Método de Pago:</h6>
                                    <p class="mb-0 small"><strong>Método:</strong> <%= p.getMetodo_pago() %></p>
                                </div>
                                <div class="col-sm-6 mb-2">
                                    <h6 class="fw-bold mb-1" style="color: #7c6753;">Entrega Estimada:</h6>
                                    <p class="mb-0 small"><strong>Rango:</strong> <%= p.getFechaEntregaMin() != null ? p.getFechaEntregaMin() : "Por definirse" %> - <%= p.getFechaEntregaMax() != null ? p.getFechaEntregaMax() : "Por definirse" %></p>
                                </div>
                            </div>

                            <div class="ticket-separador-cora my-3"></div>

                            <div class="table-responsive text-start">
                                <table class="table table-borderless">
                                    <thead>
                                        <tr class="subcora" style="border-bottom: 1px solid #d1c4b9;">
                                            <th>Producto</th>
                                            <th class="text-center">Cant.</th>
                                            <th class="text-end">Subtotal</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                        if (detalles != null) {
                                            for (detallepedido d : detalles) {
                                        %>
                                        <tr class="ticket-linea-item-cora">
                                            <td><%= d.getNombreProducto() %> <small class="text-muted">(<%= d.getColor() %> / <%= d.getTalla() %>)</small></td>
                                            <td class="text-center"><%= d.getCantidad() %></td>
                                            <td class="text-end">S/. <%= String.format("%.2f", d.getSubtotal()) %></td>
                                        </tr>
                                        <%
                                            }
                                        }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                                    
                            <div class="d-flex justify-content-between mb-2 text-start">
                                <span>Subtotal:</span>
                                <span>S/. <%= String.format("%.2f", total != null ? total.getSubtotal() : 0.0) %></span>
                            </div>

                            <div class="d-flex justify-content-between mb-3 text-start">
                                <span>Costo de Delivery:</span>

                                <% if ("delivery".equalsIgnoreCase(p.getTipo_entrega())) { %>
                                    <span>
                                        <%= p.getCosto_delivery() > 0
                                                ? "S/. " + String.format("%.2f", p.getCosto_delivery())
                                                : "Por definirse" %>
                                    </span>
                                <% } else { %>
                                    <span>No aplica</span>
                                <% } %>
                            </div>

                            <div class="ticket-separador-cora my-3"></div>

                            <div class="d-flex justify-content-between align-items-center mt-3 text-start">
                                <span class="fw-bold text-uppercase" style="color: #7c6753;">Total Cancelado:</span>
                                <h4 class="fw-bold m-0" style="color: #AF2369;">S/. <%= String.format("%.2f", total != null ? total.getTotal() : 0.0) %></h4>
                            </div>
                        </div>
                    </div>

                    <!-- Botones de Acción -->
                    <div class="d-flex justify-content-center gap-3">
                        <a href="controladorproducto?accion=listar"
                               class="btn btn-carrito-action">
                            <i class="fa-solid fa-cart-arrow-down"></i>
                                Continuar comprando

                        </a>
                        <a href="controladorperfil" class="btn btn-outline-entrega py-2 px-4">
                            <i class="fa-solid fa-list me-2"></i>Mis Pedidos
                        </a>
                        <a href="controladorpagina?pagina=inicio" class="btn btn-outline-secondary py-2 px-4">
                            <i class="fa-solid fa-house me-2"></i>Inicio
                        </a>
                    </div>
                </div>
            </div>
        </main>

        <script>
            function exportarComprobantePDF() {
                const element = document.getElementById('ticketComprobante').cloneNode(true);
                
                // Add styling specifically for printing
                const container = document.createElement('div');
                container.style.padding = '30px';
                container.style.fontFamily = 'Arial, sans-serif';
                
                // Inject structural styles to print cleanly
                container.innerHTML = `
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                    <style>
                        .tarjeta-personalizada-cora {
                            border: 1px dashed #d1c4b9;
                            background: #ffffff;
                            max-width: 650px;
                            margin: 0 auto;
                        }
                        .subcora {
                            color: #7c6753;
                        }
                        .ticket-separador-cora {
                            border-top: 1px dashed #d1c4b9;
                            margin: 15px 0;
                        }
                        .ticket-linea-item-cora {
                            font-size: 0.95rem;
                        }
                    </style>
                `;
                container.appendChild(element);

                const opt = {
                    margin:       0.5,
                    filename:     'Comprobante_Pedido_#<%= p.getId_pedido() %>.pdf',
                    image:        { type: 'jpeg', quality: 0.98 },
                    html2canvas:  { scale: 2, useCORS: true },
                    jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
                };

                html2pdf().from(container).set(opt).save();
            }
        </script>

        <jsp:include page="/componentes/pie.jsp"/> 
        <jsp:include page="/componentes/mensajes.jsp" /> 
    </body>
</html>
