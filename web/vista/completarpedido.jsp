<%-- 
    Document   : completarpedido
    Created on : 16 jun. 2026, 1:00:25 a. m.
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, modelo.ItemCarrito"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Completar pedido</title>
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
    </head>
    <body>
        <%
            request.setAttribute("paginaActual", "completarpedido");        
            List<ItemCarrito> cartItems = (List<ItemCarrito>) session.getAttribute("carrito");
            double cartSubtotal = 0.0;
            if (cartItems != null) {
                for (ItemCarrito item : cartItems) {
                    cartSubtotal += item.getPrecio() * item.getCantidad();
                }
            }
        %>
        <jsp:include page="/componentes/encabezado.jsp" />

        <main class="container mt-5 pt-4" style="margin-top: 180px; margin-bottom: 150px;"> 
            <h2 class="mb-5 text-center">Completar mi pedido</h2>
            
            <div class="row g-4 container-cuenta mx-auto">
                
                <div class="col-lg-7">
                    <div class="card tarjeta-personalizada-cora shadow-sm p-5 h-100">
                        
                        <h4 class="card-title text-center mb-4" style="color: #7c6753;">
                            <i class="fa-solid fa-truck-ramp-box me-2"></i>Tipo de Entrega
                        </h4>
                        
                        <div class="d-flex justify-content-center gap-3 mb-4">
                            <div class="flex-grow-1">
                                <input type="radio" class="btn-check btn-check-entrega" name="tipoEntregaToggle" id="btn-delivery" autocomplete="off" checked>
                                <label class="btn btn-outline-entrega w-100 rounded-pill py-2" for="btn-delivery" style="font-size: 1.05rem;">
                                    <i class="fa-solid fa-motorcycle me-2"></i>Delivery a Domicilio
                                </label>
                            </div>
                            <div class="flex-grow-1">
                                <input type="radio" class="btn-check btn-check-entrega" name="tipoEntregaToggle" id="btn-retiro" autocomplete="off">
                                <label class="btn btn-outline-entrega w-100 rounded-pill py-2" for="btn-retiro" style="font-size: 1.05rem;">
                                    <i class="fa-solid fa-shop me-2"></i>Recojo en Tienda
                                </label>
                            </div>
                        </div>

                        <hr class="mb-4" style="color: #AF2369;">

                        <div>
                            <div id="form-delivery-container">
                                <form action="procesar_pedido.jsp" method="POST" onsubmit="return validarFechasDelivery()">
                                    <input type="hidden" name="modalidad" value="delivery">
                                    
                                    <div class="mb-4">
                                        <label class="form-label subcora fw-bold">Dirección de entrega</label>

                                        <div class="row g-2">
                                            <div class="col-6">
                                                <input type="text" name="direccion" class="form-control input-cora input-redondeado-cora mb-2" placeholder="Calle, Avenida, Número..." required>
                                            </div>
                                            <div class="col-6">
                                                <input type="text" name="distrito" class="form-control input-cora input-redondeado-cora" placeholder="Distrito (e.g. Miraflores)..." required>
                                            </div>
                                        </div>                                        
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label subcora fw-bold">Fechas sugeridas de envío (exacto 2 días de intervalo)</label>
                                        <div class="row g-2">
                                            <div class="col-6">
                                                <input type="date" id="fechaMinDel" name="fechaMin" class="form-control input-cora input-redondeado-cora" required>
                                            </div>
                                            <div class="col-6">
                                                <input type="date" id="fechaMaxDel" name="fechaMax" class="form-control input-cora input-redondeado-cora" required>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label subcora fw-bold">Método de pago preferido</label>
                                        <div class="d-flex gap-2">
                                            <input type="radio" class="btn-check" name="metodoPago" id="tarjeta_del" value="Tarjeta" checked>
                                            <label class="btn btn-pago-cora rounded-pill px-3 flex-grow-1 text-center" for="tarjeta_del">Tarjeta</label>

                                            <input type="radio" class="btn-check" name="metodoPago" id="yape_del" value="Yape">
                                            <label class="btn btn-pago-cora rounded-pill px-3 flex-grow-1 text-center" for="yape_del">Yape</label>

                                            <input type="radio" class="btn-check" name="metodoPago" id="efectivo_del" value="Efectivo">
                                            <label class="btn btn-pago-cora rounded-pill px-3 flex-grow-1 text-center" for="efectivo_del">Efectivo</label>
                                        </div>
                                    </div>

                                    <div class="text-center mt-5">
                                        <button type="submit" class="btn btn-confirmar" <%= (cartItems == null || cartItems.isEmpty()) ? "disabled" : "" %>>Confirmar Pedido</button>
                                    </div>
                                </form>
                            </div>

                            <div id="form-retiro-container" class="d-none">
                                <form action="procesar_pedido.jsp" method="POST" onsubmit="return validarFechasRetiro()">
                                    <input type="hidden" name="modalidad" value="fisico">
                                    
                                    <div class="mb-4">
                                        <label class="form-label subcora fw-bold">Fechas sugeridas de recojo en tienda (exacto 2 días de intervalo)</label>
                                        <div class="row g-2">
                                            <div class="col-6">
                                                <input type="date" id="fechaMinRet" name="fechaMin" class="form-control input-cora input-redondeado-cora" required>
                                            </div>
                                            <div class="col-6">
                                                <input type="date" id="fechaMaxRet" name="fechaMax" class="form-control input-cora input-redondeado-cora" required>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label subcora fw-bold">Método de pago al retirar</label>
                                        <div class="d-flex gap-2">
                                            <input type="radio" class="btn-check" name="metodoPago" id="tarjeta_ret" value="Tarjeta" checked>
                                            <label class="btn btn-pago-cora rounded-pill px-3 flex-grow-1 text-center" for="tarjeta_ret">Tarjeta</label>

                                            <input type="radio" class="btn-check" name="metodoPago" id="yape_ret" value="Yape">
                                            <label class="btn btn-pago-cora rounded-pill px-3 flex-grow-1 text-center" for="yape_ret">Yape</label>

                                            <input type="radio" class="btn-check" name="metodoPago" id="efectivo_ret" value="Efectivo">
                                            <label class="btn btn-pago-cora rounded-pill px-3 flex-grow-1 text-center" for="efectivo_ret">Efectivo</label>
                                        </div>
                                    </div>

                                    <div class="text-center mt-5">
                                        <button type="submit" class="btn btn-confirmar" <%= (cartItems == null || cartItems.isEmpty()) ? "disabled" : "" %>>Confirmar Pedido</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                    </div>
                </div>
                
                <div class="col-lg-5">
                    <div class="card tarjeta-personalizada-cora shadow-sm p-5 h-100">
                        
                        <h4 class="card-title text-center mb-4" style="color: #7c6753;">
                            <i class="fa-solid fa-receipt me-2"></i>Resumen de Compra
                        </h4>

                        <div class="ticket-contenedor-cora">
                            
                            <div class="ticket-header-cora">
                                <span class="d-block fw-bold subcora text-uppercase" style="letter-spacing: 1px; font-size: 0.95rem;">Cora: hecho a mano</span>
                                <small class="text-muted">Ropa & Accesorios</small>
                            </div>

                            <div class="ticket-cuerpo">
                                <%
                                if (cartItems != null && !cartItems.isEmpty()) {
                                    for (ItemCarrito item : cartItems) {
                                %>
                                <div class="ticket-linea-item-cora mb-3">
                                    <div class="d-flex justify-content-between fw-bold text-wrap">
                                        <span><%= item.getNombre() %></span>
                                        <span>S/ <%= String.format("%.2f", item.getPrecio() * item.getCantidad()) %></span>
                                    </div>
                                    <div class="d-flex justify-content-start text-muted" style="font-size: 0.85rem;">
                                        <span>Cant: <%= item.getCantidad() %></span>
                                        <span class="ms-4">Color: <%= item.getColor() %></span>
                                        <span class="ms-4">Talla: <%= item.getTalla() %></span>
                                    </div>
                                </div>
                                <%
                                    }
                                } else {
                                %>
                                <p class="text-center text-muted">Su carrito está vacío.</p>
                                <%
                                }
                                %>

                                <div class="ticket-separador-cora"></div>

                                <div class="d-flex justify-content-between text-muted mb-2" style="font-size: 0.9rem;">
                                    <span>Subtotal de prendas</span>
                                    <span>S/ <%= String.format("%.2f", cartSubtotal) %></span>
                                </div>
                                
                                <div class="d-flex justify-content-between text-muted mb-2" style="font-size: 0.9rem;">
                                    <span>Costo de envío</span>
                                    <span id="textoCostoEnvio" class="fw-medium" style="color: #7c6753;">
                                        Por definirse
                                    </span>
                                </div>

                                <div class="ticket-separador-cora"></div>

                                <div class="d-flex justify-content-between align-items-center ticket-total-cora mt-3">
                                    <span class="text-uppercase" style="font-size: 0.9rem; letter-spacing: 0.5px;">Importe Total:</span>
                                    <span>S/ <%= String.format("%.2f", cartSubtotal) %></span>
                                </div>
                                
                            </div> 

                        </div> </div>
                </div>
                
            </div> </main>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const rdoDelivery = document.getElementById('btn-delivery');
                const rdoRetiro = document.getElementById('btn-retiro');
                
                const formDelivery = document.getElementById('form-delivery-container');
                const formRetiro = document.getElementById('form-retiro-container');
                const textoCostoEnvio = document.getElementById('textoCostoEnvio');
                rdoDelivery.addEventListener('change', function() {
                    if (this.checked) {
                        formDelivery.classList.remove('d-none');
                        formRetiro.classList.add('d-none');

                        textoCostoEnvio.textContent = "Por definirse";
                    }
                });

                rdoRetiro.addEventListener('change', function() {
                    if (this.checked) {
                        formRetiro.classList.remove('d-none');
                        formDelivery.classList.add('d-none');

                        textoCostoEnvio.textContent = "No aplica";
                    }
                });

                const today = new Date().toISOString().split('T')[0];
                document.getElementById('fechaMinDel').setAttribute('min', today);
                document.getElementById('fechaMaxDel').setAttribute('min', today);
                document.getElementById('fechaMinRet').setAttribute('min', today);
                document.getElementById('fechaMaxRet').setAttribute('min', today);
            });

            function validarIntervaloFechas(fechaMinId, fechaMaxId) {
                const fMin = document.getElementById(fechaMinId).value;
                const fMax = document.getElementById(fechaMaxId).value;
                
                if (!fMin || !fMax) {
                    alertify.error("Debe seleccionar ambas fechas.");
                    return false;
                }
                
                const dateMin = new Date(fMin);
                const dateMax = new Date(fMax);
                
                dateMin.setHours(0,0,0,0);
                dateMax.setHours(0,0,0,0);
                
                const diffTime = Math.abs(dateMax - dateMin);
                const diffDays = Math.round(diffTime / (1000 * 60 * 60 * 24));
                
                if (dateMax <= dateMin) {
                    alertify.error("La fecha máxima debe ser posterior a la fecha mínima.");
                    return false;
                }
                
                if (diffDays !== 2) {
                    alertify.error("Las fechas sugeridas deben tener exactamente 2 días de intervalo (ej. del 23 al 25).");
                    return false;
                }
                return true;
            }

            function validarFechasDelivery() {
                return validarIntervaloFechas('fechaMinDel', 'fechaMaxDel');
            }

            function validarFechasRetiro() {
                return validarIntervaloFechas('fechaMinRet', 'fechaMaxRet');
            }
        </script>

        <jsp:include page="/componentes/pie.jsp"/> 
        <jsp:include page="/componentes/mensajes.jsp" /> 
    </body>
</html>