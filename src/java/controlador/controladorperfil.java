
package controlador;

import dao.pedidodao;
import dao.pedidoperfildao;
import dao.perfildao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.List;
import modelo.usuarios;

/**
 *
 * @author USUARIO
 */
@WebServlet(name = "controladorperfil", urlPatterns = {"/controladorperfil"})
@MultipartConfig
public class controladorperfil extends HttpServlet {

    private perfildao dao = new perfildao();
    private pedidodao pdao = new pedidodao();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer id = (Integer) session.getAttribute("id");
        String rol = (String) session.getAttribute("rol");

        if (id != null) {
            usuarios usu = dao.obtenerPerfil(id);
            request.setAttribute("datosUsuario", usu);
            request.setAttribute("paginaActual", "perfil");

            if ("admin".equals(rol)) {
                request.getRequestDispatcher("/vista/gperfil.jsp").forward(request, response);
            } else {
                
                List<modelo.pedido> misPedidos = pdao.listarPorUsuario(id);
                pedidoperfildao perfilDao = new pedidoperfildao();
                // resumen cliente
                request.setAttribute("totalPedidosCliente", perfilDao.obtenerTotalPedidosCliente(id));
                request.setAttribute("pedidosPendientesCliente", perfilDao.obtenerPedidosPendientesCliente(id));
                request.setAttribute("pedidosCursoCliente", perfilDao.obtenerPedidosCursoCliente(id));
                request.setAttribute("pedidosEntregadosCliente", perfilDao.obtenerPedidosEntregadosCliente(id));
                request.setAttribute("ultimoPedidoCliente", perfilDao.obtenerUltimoPedidoCliente(id));
                request.setAttribute("metodoFavoritoCliente", perfilDao.obtenerMetodoFavoritoCliente(id));
                request.setAttribute("tipoEntregaFavoritoCliente", perfilDao.obtenerTipoEntregaFavoritoCliente(id));
                request.setAttribute("listaMispedidos", misPedidos);
                request.setAttribute("productosTopCliente", perfilDao.obtenerNombresProductosMasComprados(id));
                request.setAttribute("cantidadesTopCliente", perfilDao.obtenerCantidadesProductosMasComprados(id));
                request.getRequestDispatcher("/vista/perfil.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("controladorpagina?pagina=cuenta");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer id = (Integer) session.getAttribute("id");

        if (id != null) {
            String nomUsu = request.getParameter("nombreUsuario");
            String nombre = request.getParameter("nombreCompleto");
            String correo = request.getParameter("correo");
            String tel = request.getParameter("telefono");
            String pass = request.getParameter("contrasena");
            String confirmPass = request.getParameter("confirmar_contrasena");
            String imagenActual = (String) session.getAttribute("imagen");
            String nuevaImagen = imagenActual;
            Part archivo = request.getPart("imagenPerfil");
            if (archivo != null && archivo.getSize() > 0L) {
               long var10000 = System.currentTimeMillis();
               String nombreArchivo = var10000 + "_" + Paths.get(archivo.getSubmittedFileName()).getFileName().toString();
               String ruta = this.getServletContext().getRealPath("/recursos");
               System.out.println("RUTA: " + ruta);
               File carpeta = new File(ruta);
               if (!carpeta.exists()) {
                  carpeta.mkdirs();
               }

               archivo.write(ruta + File.separator + nombreArchivo);
               nuevaImagen = nombreArchivo;
            }
            String msgError = null;

            if (tel != null && !tel.matches("\\d{9}")) {
                msgError = "El teléfono debe tener 9 dígitos numéricos.";
            } 
            else if (correo != null && !correo.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                msgError = "El formato del correo electrónico no es válido.";
            } 
            else if (nombre == null || nombre.trim().isEmpty()) {
                msgError = "El nombre completo es obligatorio.";
            } 
            else if (pass != null && !pass.isEmpty()) {
                if (pass.length() < 6) {
                    msgError = "La nueva contraseña debe tener al menos 6 caracteres.";
                } else if (!pass.equals(confirmPass)) {
                    msgError = "Las contraseñas no coinciden.";
                }
            }

            if (msgError != null) {
                session.setAttribute("error", msgError);
                session.setAttribute("editando", true);
                response.sendRedirect("controladorperfil");
                return;
            }

            if (nomUsu == null) {
                nomUsu = (String) session.getAttribute("usuario");
            }

            boolean ok = dao.actualizarPerfil(id, nomUsu, nombre, correo, tel, pass, nuevaImagen);

            if (ok) {
                session.setAttribute("usuario", nomUsu);
                session.setAttribute("imagen", nuevaImagen);
                session.setAttribute("success", "¡Perfil actualizado con éxito!");
            } else {
                session.setAttribute("error", "Error al guardar: El correo ya podría estar en uso.");
            }

            response.sendRedirect("controladorperfil");
        } else {
            response.sendRedirect("controladorseccion?seccion=inicio");
        }
    }
}
