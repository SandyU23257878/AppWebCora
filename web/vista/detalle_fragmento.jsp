<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.pedido, modelo.detallepedido, modelo.totalpedido, java.util.List"%>

<%
    pedido pedido = (pedido)request.getAttribute("pedido");
    totalpedido total =(totalpedido)request.getAttribute("totalPedido");
    List<detallepedido> detalles =(List<detallepedido>)request.getAttribute("detallePedido");
    String est = (pedido.getEstado() != null) ? pedido.getEstado().toLowerCase() : "";
%>

<div class="ticket-contenedor-cora">
    <div class="ticket-header-cora">
        <h4 class="subcora mb-0">Detalle del Pedido #<%=pedido.getId_pedido()%></h4>
    </div>

    <div class="mb-4">
        <p class="ticket-linea-item-cora mb-1"><strong>Cliente:</strong> <%=pedido.getNombreCompleto()%></p>
        <p class="ticket-linea-item-cora mb-1"><strong>Fecha:</strong> <%=pedido.getFecha_pedido()%></p>
        <p class="ticket-linea-item-cora mb-1">
            <strong>Estado:</strong> 
            <span style="text-transform: capitalize; font-weight: bold; color: <%= "cancelado".equals(est) ? "#B1564E" : "#7c6753" %>">
                <%=est%>
            </span>
        </p>
        <p class="ticket-linea-item-cora mb-0"><strong>Entrega estimada: </strong>
            <% if ("cancelado".equals(est)) { %>
                <span style="color: #B1564E; font-weight: bold;">Cancelado</span>
            <% } else if ("pendiente".equals(est)) { %>
                <span>Por definirse</span>
            <% } else if (("curso".equals(est) || "entregado".equals(est)) && pedido.getFechaEntregaMin() == null) { %>
                <span>Sin fecha aún</span>
            <% } else if (pedido.getFechaEntregaMin() != null) { %>
                <span><%= pedido.getFechaEntregaMin() %> - <%= pedido.getFechaEntregaMax() %></span>
            <% } else { %>
                <span>Por definirse</span>
            <% } %>
        </p>
    </div>

    <div class="ticket-separador-cora"></div>

    <div>
    <table class="table table-borderless" style="width:100%;">
            <thead>
                <tr class="subcora" style="border-bottom: 1px solid #d1c4b9;">
                    <th class="text-start">Producto</th>
                    <th class="text-center">Cant.</th>
                    <th class="text-end">Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <% for(detallepedido d : detalles){ %>
                <tr class="ticket-linea-item-cora">
                    <td class="text-start"><%=d.getNombreProducto()%> <small class="text-muted">(<%=d.getColor()%> / <%=d.getTalla()%>)</small></td>
                    <td class="text-center"><%=d.getCantidad()%></td>
                    <td class="text-end">S/. <%=String.format("%.2f", d.getSubtotal())%></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div class="d-flex justify-content-between mb-2">
        <span>Subtotal:</span>
        <span>S/. <%= String.format("%.2f", total.getSubtotal()) %></span>
    </div>

    <div class="d-flex justify-content-between mb-2">
        <span>Costo de Delivery:</span>

        <% if ("delivery".equalsIgnoreCase(pedido.getTipo_entrega())) { %>
            <span>
                <%= pedido.getCosto_delivery() > 0
                        ? "S/. " + String.format("%.2f", pedido.getCosto_delivery())
                        : "Por definirse" %>
            </span>
        <% } else { %>
            <span>No aplica</span>
        <% } %>
    </div>

    <div class="ticket-separador-cora"></div>

    <div class="text-end">
        <h5 class="ticket-total-cora">
            Total: S/. <%= String.format("%.2f", total.getTotal()) %>
        </h5>
    </div>
</div>