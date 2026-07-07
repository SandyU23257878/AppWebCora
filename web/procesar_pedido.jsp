<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, modelo.ItemCarrito, servicio.pedidoservicio, java.sql.Date"%>
<%
    HttpSession sess = request.getSession();
    Integer idUsuario = (Integer) sess.getAttribute("id");
    List<ItemCarrito> carrito = (List<ItemCarrito>) sess.getAttribute("carrito");

    if (idUsuario == null) {
        sess.setAttribute("error", "Necesita iniciar sesión para procesar su pedido.");
        response.sendRedirect("controladorpagina?pagina=cuenta");
        return;
    }

    if (carrito == null || carrito.isEmpty()) {
        sess.setAttribute("error", "Su carrito está vacío.");
        response.sendRedirect("controladorcarrito?accion=listar");
        return;
    }

    String modalidad = request.getParameter("modalidad");
    String direccion = request.getParameter("direccion");
    String distrito = request.getParameter("distrito");
    String fechaMinStr = request.getParameter("fechaMin");
    String fechaMaxStr = request.getParameter("fechaMax");
    String metodoPago = request.getParameter("metodoPago");

    String direccionCompleta = "Larcomar, tienda 220, lima, peru";
    double costoDelivery = 0.0;

    if ("delivery".equalsIgnoreCase(modalidad)) {
        if (direccion == null || direccion.trim().isEmpty() || distrito == null || distrito.trim().isEmpty()) {
            sess.setAttribute("error", "La dirección y el distrito son obligatorios para el delivery.");
            response.sendRedirect("controladorpagina?pagina=completarpedido");
            return;
        }
        direccionCompleta = direccion.trim() + ", " + distrito.trim();
        costoDelivery = 0.0; 
    }

    if (fechaMinStr == null || fechaMinStr.isEmpty() || fechaMaxStr == null || fechaMaxStr.isEmpty()) {
        sess.setAttribute("error", "Debe seleccionar ambas fechas de entrega sugeridas.");
        response.sendRedirect("controladorpagina?pagina=completarpedido");
        return;
    }

    Date fMin = null;
    Date fMax = null;
    try {
        fMin = Date.valueOf(fechaMinStr);
        fMax = Date.valueOf(fechaMaxStr);
    } catch (IllegalArgumentException e) {
        sess.setAttribute("error", "Formato de fechas incorrecto.");
        response.sendRedirect("controladorpagina?pagina=completarpedido");
        return;
    }

    long diffInMillies = fMax.getTime() - fMin.getTime();
    long diffInDays = Math.round((double) diffInMillies / (1000 * 60 * 60 * 24));

    if (fMax.before(fMin)) {
        sess.setAttribute("error", "La fecha máxima de entrega debe ser posterior a la fecha mínima.");
        response.sendRedirect("controladorpagina?pagina=completarpedido");
        return;
    }

    if (diffInDays != 2) {
        sess.setAttribute("error", "Las fechas estimadas deben tener exactamente 2 días de intervalo (ej. del 23 al 25).");
        response.sendRedirect("controladorpagina?pagina=completarpedido");
        return;
    }

    pedidoservicio servicio = new pedidoservicio();
    int idPedido = servicio.registrarPedidoCompletoConId(idUsuario, modalidad, costoDelivery, direccionCompleta, metodoPago, fMin, fMax, carrito);

    if (idPedido > 0) {
        sess.removeAttribute("carrito");
        sess.setAttribute("success", "¡Pedido realizado con éxito!");
        response.sendRedirect("controladorpedido?accion=exito&id=" + idPedido);
    } else {
        sess.setAttribute("error", "Hubo un error al procesar su pedido. Posiblemente no hay suficiente stock.");
        response.sendRedirect("controladorpagina?pagina=completarpedido");
    }
%>
