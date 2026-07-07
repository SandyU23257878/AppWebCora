package controlador;

import dao.pedidodao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.util.List;
import modelo.pedido;
import servicio.pedidosadminservicio;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;
import java.sql.Date;
import modelo.ItemCarrito;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;
import java.io.OutputStream;
import modelo.detallepedido;
import modelo.totalpedido;
/**
 *
 * @author USUARIO
 */
@WebServlet(name = "controladorpedido", urlPatterns = {"/controladorpedido"})
public class controladorpedido extends HttpServlet {

    private pedidodao pdao = new pedidodao();
    private final String paglistaradmin = "/vista/gpedidos.jsp";
    private pedidosadminservicio padmin = new pedidosadminservicio();
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String accion = request.getParameter("accion");

        if (accion == null || accion.isEmpty()) {
            listar(request, response);
            return;
        }

        switch (accion) {

            case "listar":
                listar(request, response);
                break;
            case "nuevo":
                nuevo(request, response);
                break;

            case "guardarAdmin":
                guardarAdmin(request, response);
                break;
            case "detalle":
                detalle(request, response);
                break;

            case "exito":
                exito(request, response);
                break;

            case "cambiarEstado":
                cambiarEstado(request, response);
                break;

            case "anular":
                anular(request, response);
                break;

            case "pendientes":
                pendientes(request, response);
                break;

            case "entregados":
                entregados(request, response);
                break;
            case "comprobante":
                generarComprobante(request, response);
                break;    
            case "actualizarDelivery":
                actualizarDelivery(request, response);
                break;
            default:
                listar(request, response);
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer id = (Integer) session.getAttribute("id");
        String rol = (String) session.getAttribute("rol");

        if (id != null) {
            if ("admin".equals(rol)) {
                List<modelo.pedido> lista = pdao.listarTodos();
                request.setAttribute("listaPedidos", lista);
                request.setAttribute("clientes",pdao.listarClientes());
                request.setAttribute("variantes",pdao.listarVariantesDisponibles());
                request.getRequestDispatcher(paglistaradmin).forward(request, response);
            } else {
                response.sendRedirect("controladorperfil");
            }

        } else {
            response.sendRedirect("controladorpagina?accion=inicio");
        }

    }

    private void detalle(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int idPedido = Integer.parseInt(request.getParameter("id"));
        Integer id = (Integer) session.getAttribute("id");
        String rol = (String) session.getAttribute("rol");
        request.setAttribute("detallePedido", pdao.detallePedido(idPedido));

        request.setAttribute("pedido", pdao.obtenerPedido(idPedido));

        request.setAttribute("totalPedido", pdao.obtenerTotal(idPedido));

        if ("admin".equals(rol)) {
            request.getRequestDispatcher("/vista/detallepedido.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/vista/detalle_fragmento.jsp").forward(request, response);
        }

    }

    private void cambiarEstado(HttpServletRequest request,HttpServletResponse response)
        throws IOException {

        HttpSession session = request.getSession();

        int idPedido = Integer.parseInt(request.getParameter("id"));

        pedido p = pdao.obtenerPedido(idPedido);

        if (p != null &&"cancelado".equalsIgnoreCase(p.getEstado())) {

            session.setAttribute("error","No se puede modificar un pedido cancelado.");

            response.sendRedirect("controladorpedido?accion=listar");
            return;
        }

        String estado = request.getParameter("estado");
        String fechaMinStr = request.getParameter("fechaMin");
        String fechaMaxStr = request.getParameter("fechaMax");

        Date fechaMin = null;
        Date fechaMax = null;

        if(fechaMinStr != null && !fechaMinStr.isEmpty()){
            fechaMin = Date.valueOf(fechaMinStr);
        }

        if(fechaMaxStr != null && !fechaMaxStr.isEmpty()){
            fechaMax = Date.valueOf(fechaMaxStr);
        }

        // Validation of delivery dates max and min (2 days interval)
        if ("curso".equalsIgnoreCase(estado) || "entregado".equalsIgnoreCase(estado)) {
            if (fechaMin == null || fechaMax == null) {
                session.setAttribute("error", "Las fechas de entrega son obligatorias para pedidos en curso o entregados.");
                response.sendRedirect("controladorpedido?accion=listar");
                return;
            }
            long diff = (fechaMax.getTime() - fechaMin.getTime()) / (1000 * 60 * 60 * 24);
            if (diff != 2) {
                session.setAttribute("error", "El intervalo de entrega debe ser de exactamente 2 días.");
                response.sendRedirect("controladorpedido?accion=listar");
                return;
            }
        }

        if (pdao.cambiarEstado(idPedido, estado,fechaMin,fechaMax)) {

            session.setAttribute("success", "Estado actualizado correctamente.");

        } else {

            session.setAttribute("error", "No se pudo actualizar el estado.");

        }

        response.sendRedirect("controladorpedido?accion=listar");
    }

    private void anular(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        int idPedido = Integer.parseInt(request.getParameter("id"));
        pedido p = pdao.obtenerPedido(idPedido);

        if(p != null &&
           "cancelado".equalsIgnoreCase(p.getEstado())){

            session.setAttribute("error", "El pedido ya se encuentra cancelado.");

            response.sendRedirect("controladorpedido?accion=listar");
            return;
        }
        pdao.anularPedido(idPedido);
        
        response.sendRedirect("controladorpedido?accion=listar");
    }

    private void pendientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<pedido> lista = pdao.listarPendientes();

        request.setAttribute("listaPedidos", lista);

        request.getRequestDispatcher(paglistaradmin).forward(request, response);
    }

    private void entregados(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<pedido> lista = pdao.listarEntregados();

        request.setAttribute("listaPedidos", lista);

        request.getRequestDispatcher(paglistaradmin).forward(request, response);
    }
    
    private void nuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("clientes", pdao.listarClientes());

        request.setAttribute("variantes", pdao.listarVariantesDisponibles());

        request.getRequestDispatcher("controladorpedido?accion=listar").forward(request, response);
    }
    
    private void guardarAdmin(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
        HttpSession session = request.getSession();
        String idUsuarioStr = request.getParameter("idUsuario");

        if(idUsuarioStr == null || idUsuarioStr.isEmpty()){
            session.setAttribute("error", "Debe seleccionar un cliente.");
            response.sendRedirect("controladorpedido?accion=listar");
            return;
        }

        int idUsuario = Integer.parseInt(idUsuarioStr);
        String tipoEntrega = request.getParameter("tipoEntrega");

        if(tipoEntrega == null ||
           (!tipoEntrega.equals("delivery")
            && !tipoEntrega.equals("fisico"))){

            session.setAttribute(
                "error",
                "Debe seleccionar un tipo de entrega válido."
            );

            response.sendRedirect(
                "controladorpedido?accion=listar"
            );

            return;
        }

        String costoStr = request.getParameter("costoDelivery");

        double costoDelivery = 0;

        if(costoStr != null && !costoStr.trim().isEmpty()){
            costoDelivery = Double.parseDouble(costoStr);
        }

        if(costoDelivery < 0){

            session.setAttribute(
                "error",
                "El costo de delivery no puede ser negativo."
            );

            response.sendRedirect(
                "controladorpedido?accion=listar"
            );

            return;
        }

        String direccion =request.getParameter("direccion");

        if("delivery".equals(tipoEntrega)){

            if(direccion == null ||
               direccion.trim().isEmpty()){

                session.setAttribute(
                    "error",
                    "Debe ingresar una dirección para delivery."
                );

                response.sendRedirect(
                    "controladorpedido?accion=listar"
                );

                return;
            }

        }
        
        String metodoPago = request.getParameter("metodoPago");

        if(metodoPago == null ||
           metodoPago.trim().isEmpty()){

            session.setAttribute(
                "error",
                "Debe seleccionar un método de pago."
            );

            response.sendRedirect(
                "controladorpedido?accion=listar"
            );

            return;
        }
        String estado = "pendiente";
        String carritoJson = request.getParameter("carrito");
        if(carritoJson == null ||
           carritoJson.trim().isEmpty()){

            session.setAttribute(
                "error",
                "Debe agregar al menos un producto."
            );

            response.sendRedirect(
                "controladorpedido?accion=listar"
            );

            return;
        }
        Gson gson = new Gson();
        Type listType = new TypeToken<List<ItemCarrito>>(){}.getType();

        List<ItemCarrito> carrito = gson.fromJson(carritoJson, listType);

        if(carrito == null || carrito.isEmpty()){

            session.setAttribute(
                "error",
                "Debe agregar al menos un producto."
            );

            response.sendRedirect(
                "controladorpedido?accion=listar"
            );

            return;
        }

        
        boolean ok = padmin.registrarPedidoAdmin( idUsuario,tipoEntrega,costoDelivery,direccion, metodoPago,estado, carrito);
        if (ok) {
            session.setAttribute("success","El pedido se registró correctamente.");
        }else{
            session.setAttribute("error","No se pudo registrar el pedido." );
        }
        response.sendRedirect("controladorpedido?accion=listar");
    }

    private void exito(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer id = (Integer) session.getAttribute("id");
        if (id == null) {
            response.sendRedirect("controladorpagina?pagina=cuenta");
            return;
        }

        int idPedido = Integer.parseInt(request.getParameter("id"));
        pedido p = pdao.obtenerPedido(idPedido);

        // Security check: ensure the client only sees their own order success page
        if (p == null || (p.getId_usuario() != id && !"admin".equals(session.getAttribute("rol")))) {
            response.sendRedirect("controladorperfil");
            return;
        }

        request.setAttribute("pedido", p);
        request.setAttribute("totalPedido", pdao.obtenerTotal(idPedido));
        request.setAttribute("detallePedido", pdao.detallePedido(idPedido));
        request.getRequestDispatcher("/vista/pedidorealizado.jsp").forward(request, response);
    }
    
    
    private void generarComprobante(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
        HttpSession session = request.getSession();
        Integer idSesion = (Integer) session.getAttribute("id");
        String rol = (String) session.getAttribute("rol");

        if (idSesion == null) {
            response.sendRedirect("controladorpagina?accion=inicio");
            return;
        }

        int idPedido = Integer.parseInt(request.getParameter("id"));

        pedido p = pdao.obtenerPedido(idPedido);
        if (p == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Pedido no encontrado.");
            return;
        }

        // Seguridad: si no es admin, solo puede descargar su propio pedido
        if (!"admin".equals(rol) && p.getId_usuario() != idSesion) {
            response.sendRedirect("controladorperfil");
            return;
        }

        List<detallepedido> detalles = pdao.detallePedido(idPedido);
        totalpedido total = pdao.obtenerTotal(idPedido);

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=Comprobante_Pedido_" + idPedido + ".pdf");

        Document document = new Document(PageSize.A4, 36, 36, 40, 40);

        try {
            OutputStream out = response.getOutputStream();
            PdfWriter.getInstance(document, out);
            document.open();

            // ========= COLORES =========
            BaseColor colorPrincipal = new BaseColor(242, 223, 221); // #F2DFDD
            BaseColor colorMarron = new BaseColor(124, 103, 83);     // marrón texto
            BaseColor colorMarronOsc = new BaseColor(92, 74, 60);    // marrón más fuerte
            BaseColor colorBeige = new BaseColor(250, 248, 245);     // fondo suave
            BaseColor colorLinea = new BaseColor(214, 195, 185);     // líneas
            BaseColor colorBlanco = BaseColor.WHITE;

            // ========= FUENTES =========
            Font tituloFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, colorMarronOsc);
            Font subtituloFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, colorMarron);
            Font seccionFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, colorMarronOsc);
            Font labelFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, colorMarronOsc);
            Font textoFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.BLACK);
            Font textoSuaveFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, colorMarron);
            Font totalFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, colorMarronOsc);
            Font totalValorFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, colorMarronOsc);
            Font tablaHeaderFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, colorMarronOsc);

            // ========= LOGO + ENCABEZADO =========
            PdfPTable cabecera = new PdfPTable(2);
            cabecera.setWidthPercentage(100);
            cabecera.setWidths(new float[]{1.2f, 4f});
            cabecera.setSpacingAfter(12f);

            PdfPCell celdaLogo;
            try {
                String rutaLogo = getServletContext().getRealPath("/recursos/logo_cora.png");
                Image logo = Image.getInstance(rutaLogo);
                logo.scaleToFit(70, 70);

                celdaLogo = new PdfPCell(logo, false);
            } catch (Exception e) {
                // Si el logo falla, deja una celda vacía para no romper el PDF
                celdaLogo = new PdfPCell(new Phrase(""));
            }

            celdaLogo.setBorder(Rectangle.NO_BORDER);
            celdaLogo.setVerticalAlignment(Element.ALIGN_MIDDLE);
            celdaLogo.setHorizontalAlignment(Element.ALIGN_CENTER);
            celdaLogo.setPadding(5f);

            PdfPCell celdaTitulo = new PdfPCell();
            celdaTitulo.setBorder(Rectangle.NO_BORDER);
            celdaTitulo.setVerticalAlignment(Element.ALIGN_MIDDLE);
            celdaTitulo.setPaddingLeft(10f);

            Paragraph titulo = new Paragraph("CORA: Hecho a Mano", tituloFont);
            titulo.setSpacingAfter(4f);

            Paragraph subtitulo = new Paragraph("Comprobante de pedido", subtituloFont);
            Paragraph subtitulo2 = new Paragraph("Gracias por tu compra", subtituloFont);

            celdaTitulo.addElement(titulo);
            celdaTitulo.addElement(subtitulo);
            celdaTitulo.addElement(subtitulo2);

            cabecera.addCell(celdaLogo);
            cabecera.addCell(celdaTitulo);

            document.add(cabecera);

            // Línea decorativa
            LineSeparator lineaTop = new LineSeparator();
            lineaTop.setLineColor(colorLinea);
            lineaTop.setLineWidth(1.2f);
            document.add(new Chunk(lineaTop));
            document.add(Chunk.NEWLINE);

            // ========= BLOQUE SUPERIOR: DATOS PEDIDO =========
            PdfPTable infoPedido = new PdfPTable(2);
            infoPedido.setWidthPercentage(100);
            infoPedido.setWidths(new float[]{1f, 1f});
            infoPedido.setSpacingAfter(14f);

            PdfPCell bloqueIzq = new PdfPCell();
            bloqueIzq.setBackgroundColor(colorBeige);
            bloqueIzq.setBorderColor(colorPrincipal);
            bloqueIzq.setBorderWidth(1f);
            bloqueIzq.setPadding(12f);

            bloqueIzq.addElement(new Paragraph("DATOS DEL PEDIDO", seccionFont));
            bloqueIzq.addElement(new Paragraph("Pedido N°: " + p.getId_pedido(), textoFont));
            bloqueIzq.addElement(new Paragraph("Fecha: " + safe(String.valueOf(p.getFecha_pedido())), textoFont));
            bloqueIzq.addElement(new Paragraph("Estado: " + safe(capitalizar(p.getEstado())), textoFont));

            PdfPCell bloqueDer = new PdfPCell();
            bloqueDer.setBackgroundColor(colorBeige);
            bloqueDer.setBorderColor(colorPrincipal);
            bloqueDer.setBorderWidth(1f);
            bloqueDer.setPadding(12f);

            bloqueDer.addElement(new Paragraph("DATOS DEL CLIENTE", seccionFont));
            bloqueDer.addElement(new Paragraph("Cliente: " + safe(p.getNombreCompleto()), textoFont));
            bloqueDer.addElement(new Paragraph("Tipo de entrega: " + safe(capitalizar(p.getTipo_entrega())), textoFont));
            bloqueDer.addElement(new Paragraph("Dirección: " +
                    (p.getDireccion() == null || p.getDireccion().trim().isEmpty() ? "No aplica" : p.getDireccion()), textoFont));

            infoPedido.addCell(bloqueIzq);
            infoPedido.addCell(bloqueDer);

            document.add(infoPedido);

            // ========= ENTREGA ESTIMADA =========
            String entrega;
            String est = p.getEstado() != null ? p.getEstado().toLowerCase() : "";

            if ("cancelado".equals(est)) {
                entrega = "Cancelado";
            } else if ("pendiente".equals(est)) {
                entrega = "Por definirse";
            } else if (("curso".equals(est) || "entregado".equals(est)) && p.getFechaEntregaMin() == null) {
                entrega = "Sin fecha aún";
            } else if (p.getFechaEntregaMin() != null) {
                entrega = p.getFechaEntregaMin() + " - " + p.getFechaEntregaMax();
            } else {
                entrega = "Por definirse";
            }

            PdfPTable tablaEntrega = new PdfPTable(1);
            tablaEntrega.setWidthPercentage(100);
            tablaEntrega.setSpacingAfter(12f);

            PdfPCell celdaEntrega = new PdfPCell();
            celdaEntrega.setBackgroundColor(colorPrincipal);
            celdaEntrega.setBorderColor(colorLinea);
            celdaEntrega.setPadding(10f);
            celdaEntrega.addElement(new Paragraph("Entrega estimada: " + entrega, labelFont));

            tablaEntrega.addCell(celdaEntrega);
            document.add(tablaEntrega);

            // ========= TABLA DE PRODUCTOS =========
            Paragraph tituloProductos = new Paragraph("DETALLE DE PRODUCTOS", seccionFont);
            tituloProductos.setSpacingAfter(8f);
            document.add(tituloProductos);

            PdfPTable tabla = new PdfPTable(3);
            tabla.setWidthPercentage(100);
            tabla.setWidths(new float[]{5.5f, 1.5f, 2f});
            tabla.setSpacingAfter(14f);

            PdfPCell c1 = new PdfPCell(new Phrase("Producto", tablaHeaderFont));
            PdfPCell c2 = new PdfPCell(new Phrase("Cant.", tablaHeaderFont));
            PdfPCell c3 = new PdfPCell(new Phrase("Subtotal", tablaHeaderFont));

            c1.setBackgroundColor(colorPrincipal);
            c2.setBackgroundColor(colorPrincipal);
            c3.setBackgroundColor(colorPrincipal);

            c1.setBorderColor(colorLinea);
            c2.setBorderColor(colorLinea);
            c3.setBorderColor(colorLinea);

            c1.setPadding(8f);
            c2.setPadding(8f);
            c3.setPadding(8f);

            c1.setHorizontalAlignment(Element.ALIGN_LEFT);
            c2.setHorizontalAlignment(Element.ALIGN_CENTER);
            c3.setHorizontalAlignment(Element.ALIGN_RIGHT);

            tabla.addCell(c1);
            tabla.addCell(c2);
            tabla.addCell(c3);

            boolean alternar = false;

            for (detallepedido d : detalles) {
                String nombreProducto = safe(d.getNombreProducto())
                        + " (" + safe(d.getColor()) + " / " + safe(d.getTalla()) + ")";

                BaseColor fondoFila = alternar ? colorBeige : colorBlanco;

                PdfPCell prod = new PdfPCell(new Phrase(nombreProducto, textoFont));
                PdfPCell cant = new PdfPCell(new Phrase(String.valueOf(d.getCantidad()), textoFont));
                PdfPCell sub = new PdfPCell(new Phrase("S/. " + String.format("%.2f", d.getSubtotal()), textoFont));

                prod.setBackgroundColor(fondoFila);
                cant.setBackgroundColor(fondoFila);
                sub.setBackgroundColor(fondoFila);

                prod.setBorderColor(colorLinea);
                cant.setBorderColor(colorLinea);
                sub.setBorderColor(colorLinea);

                prod.setPadding(8f);
                cant.setPadding(8f);
                sub.setPadding(8f);

                cant.setHorizontalAlignment(Element.ALIGN_CENTER);
                sub.setHorizontalAlignment(Element.ALIGN_RIGHT);

                tabla.addCell(prod);
                tabla.addCell(cant);
                tabla.addCell(sub);

                alternar = !alternar;
            }

            document.add(tabla);

            // ========= RESUMEN DE PAGO =========
            Paragraph tituloResumen = new Paragraph("RESUMEN DE PAGO", seccionFont);
            tituloResumen.setSpacingAfter(8f);
            document.add(tituloResumen);

            String deliveryTexto = "No aplica";
            if ("delivery".equalsIgnoreCase(p.getTipo_entrega())) {
                deliveryTexto = p.getCosto_delivery() > 0
                        ? "S/. " + String.format("%.2f", p.getCosto_delivery())
                        : "Por definirse";
            }

            PdfPTable tablaTotales = new PdfPTable(2);
            tablaTotales.setWidthPercentage(45);
            tablaTotales.setHorizontalAlignment(Element.ALIGN_RIGHT);
            tablaTotales.setWidths(new float[]{2.3f, 1.2f});
            tablaTotales.setSpacingBefore(5f);

            PdfPCell t1 = new PdfPCell(new Phrase("Subtotal", labelFont));
            PdfPCell t2 = new PdfPCell(new Phrase("S/. " + String.format("%.2f", total.getSubtotal()), textoFont));

            PdfPCell d1 = new PdfPCell(new Phrase("Delivery", labelFont));
            PdfPCell d2 = new PdfPCell(new Phrase(deliveryTexto, textoFont));

            PdfPCell tt1 = new PdfPCell(new Phrase("TOTAL", totalFont));
            PdfPCell tt2 = new PdfPCell(new Phrase("S/. " + String.format("%.2f", total.getTotal()), totalValorFont));

            PdfPCell[] celdas = {t1, t2, d1, d2, tt1, tt2};
            for (PdfPCell celda : celdas) {
                celda.setBorderColor(colorLinea);
                celda.setPadding(8f);
            }

            t1.setBackgroundColor(colorBeige);
            t2.setBackgroundColor(colorBeige);
            d1.setBackgroundColor(colorBeige);
            d2.setBackgroundColor(colorBeige);

            tt1.setBackgroundColor(colorPrincipal);
            tt2.setBackgroundColor(colorPrincipal);

            t2.setHorizontalAlignment(Element.ALIGN_RIGHT);
            d2.setHorizontalAlignment(Element.ALIGN_RIGHT);
            tt2.setHorizontalAlignment(Element.ALIGN_RIGHT);

            tablaTotales.addCell(t1);
            tablaTotales.addCell(t2);
            tablaTotales.addCell(d1);
            tablaTotales.addCell(d2);
            tablaTotales.addCell(tt1);
            tablaTotales.addCell(tt2);

            document.add(tablaTotales);

            // ========= PIE =========
            document.add(Chunk.NEWLINE);
            document.add(Chunk.NEWLINE);

            LineSeparator lineaBottom = new LineSeparator();
            lineaBottom.setLineColor(colorLinea);
            lineaBottom.setLineWidth(1f);
            document.add(new Chunk(lineaBottom));
            document.add(Chunk.NEWLINE);

            Paragraph gracias = new Paragraph(
                    "Gracias por confiar en CORA: Hecho a Mano.",
                    textoSuaveFont
            );
            gracias.setAlignment(Element.ALIGN_CENTER);
            document.add(gracias);

            document.close();
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.reset();
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("Error al generar el comprobante PDF.");
        }
    }
    private String safe(String valor) {
        return valor == null ? "" : valor;
    }

    private String capitalizar(String texto) {
        if (texto == null || texto.trim().isEmpty()) return "";
        texto = texto.toLowerCase();
        return Character.toUpperCase(texto.charAt(0)) + texto.substring(1);
    }
    private void agregarFilaInfo(PdfPTable tabla, String etiqueta, String valor,Font labelFont, Font valorFont, BaseColor fondo, BaseColor borde) {

        PdfPCell c1 = new PdfPCell(new Phrase(etiqueta, labelFont));
        PdfPCell c2 = new PdfPCell(new Phrase(valor, valorFont));

        c1.setBackgroundColor(fondo);
        c2.setBackgroundColor(fondo);

        c1.setBorderColor(borde);
        c2.setBorderColor(borde);

        c1.setPadding(7f);
        c2.setPadding(7f);

        tabla.addCell(c1);
        tabla.addCell(c2);
    }

    private void agregarFilaTotal(PdfPTable tabla, String etiqueta, String valor,
            Font labelFont, Font valorFont, BaseColor fondo, BaseColor borde) {

        PdfPCell c1 = new PdfPCell(new Phrase(etiqueta, labelFont));
        PdfPCell c2 = new PdfPCell(new Phrase(valor, valorFont));

        c1.setBackgroundColor(fondo);
        c2.setBackgroundColor(fondo);

        c1.setBorderColor(borde);
        c2.setBorderColor(borde);

        c1.setPadding(7f);
        c2.setPadding(7f);

        c1.setHorizontalAlignment(Element.ALIGN_LEFT);
        c2.setHorizontalAlignment(Element.ALIGN_RIGHT);

        tabla.addCell(c1);
        tabla.addCell(c2);
    }

    private Font obtenerFontEstado(String estado) {
        if (estado == null) estado = "";

        switch (estado.toLowerCase()) {
            case "pendiente":
                return new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, new BaseColor(184, 134, 11));
            case "curso":
                return new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, new BaseColor(166, 139, 109));
            case "entregado":
                return new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, new BaseColor(85, 107, 47));
            case "cancelado":
                return new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, new BaseColor(177, 86, 78));
            default:
                return new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, new BaseColor(60, 60, 60));
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void actualizarDelivery(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        try {
            int idPedido = Integer.parseInt(request.getParameter("idPedido"));
            double costoDelivery = Double.parseDouble(request.getParameter("costoDelivery"));

            if (costoDelivery < 0) {
                request.getSession().setAttribute("error", "El costo de delivery no puede ser negativo.");
                response.sendRedirect("controladorpedido?accion=listar");
                return;
            }

            pedidodao dao = new pedidodao();
            boolean ok = dao.actualizarCostoDelivery(idPedido, costoDelivery);

            if (ok) {
                request.getSession().setAttribute("success", "Costo de delivery actualizado correctamente.");
            } else {
                request.getSession().setAttribute("error", "No se pudo actualizar el costo de delivery.");
            }

        }  catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "El monto ingresado no es válido.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Ocurrió un error al actualizar el costo de delivery.");
        }

        response.sendRedirect("controladorpedido?accion=listar");
    }
}
