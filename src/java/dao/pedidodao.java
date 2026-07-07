package dao;

import conexion.conexioncora_bd;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.detallepedido;
import modelo.pedido;
import modelo.productos;
import modelo.totalpedido;
import modelo.usuarios;

public class pedidodao {

    private Connection cn = null;
    private CallableStatement cs = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;


    // Mostrar lista de pedidos
    public List<pedido> listarTodos() {
        cn = conexioncora_bd.probarConexion();
        List<pedido> lista = new ArrayList<>();

        try {

            cs = cn.prepareCall("{CALL sp_mostrar_pedidos()}");

            rs = cs.executeQuery();

            while (rs.next()) {

                pedido p = new pedido();

                p.setId_pedido(rs.getInt("id_pedido"));
                p.setId_usuario(rs.getInt("id_usuario"));
                p.setNombreCompleto(rs.getString("nombre_completo"));
                p.setFecha_pedido(rs.getString("fecha_pedido"));
                p.setTipo_entrega(rs.getString("tipo_entrega"));
                p.setCosto_delivery(rs.getDouble("costo_delivery"));
                p.setDireccion(rs.getString("direccion"));
                p.setMetodo_pago(rs.getString("metodo_pago"));
                p.setEstado(rs.getString("estado"));
                p.setFechaEntregaMin(rs.getDate("fecha_entrega_min"));
                p.setFechaEntregaMax(rs.getDate("fecha_entrega_max"));
                lista.add(p);
            }

        } catch (Exception e) {
            System.out.println("Error listarTodos: " + e.getMessage());
        }finally {
            cerrarRecursos();
        }

        return lista;
    }

    // listar pedidos para vista usuario cliente
    public List<pedido> listarPorUsuario(int idUsuario) {

        List<pedido> lista = new ArrayList<>();
        cn = conexioncora_bd.probarConexion();
        try {

            cs = cn.prepareCall("{CALL sp_mis_pedidos(?)}");

            cs.setInt(1, idUsuario);

            rs = cs.executeQuery();

            while (rs.next()) {

                pedido p = new pedido();

                p.setId_pedido(rs.getInt("id_pedido"));
                p.setId_usuario(rs.getInt("id_usuario"));
                p.setFecha_pedido(rs.getString("fecha_pedido"));
                p.setTipo_entrega(rs.getString("tipo_entrega"));
                p.setCosto_delivery(rs.getDouble("costo_delivery"));
                p.setDireccion(rs.getString("direccion"));
                p.setMetodo_pago(rs.getString("metodo_pago"));
                p.setEstado(rs.getString("estado"));
                p.setFechaEntregaMin(rs.getDate("fecha_entrega_min"));
                p.setFechaEntregaMax(rs.getDate("fecha_entrega_max"));
                lista.add(p);
            }

        } catch (Exception e) {
            System.out.println("Error listarPorUsuario: " + e.getMessage());
        }finally {
            cerrarRecursos();
        }

        return lista;
    }

    // Crear pedido, para vista cliente y admin
    public int crearPedido(int idUsuario, String tipoEntrega, double costoDelivery, String direccion,String metodoPago) {

        int idPedido = 0;
        cn = conexioncora_bd.probarConexion();
        try {

            cs =cn.prepareCall("{CALL sp_crear_pedido(?,?,?,?,?,?)}");

            cs.setInt(1, idUsuario);
            cs.setString(2, tipoEntrega);
            cs.setDouble(3, costoDelivery);
            cs.setString(4, direccion);
            cs.setString(5, metodoPago);

            cs.registerOutParameter(6, Types.INTEGER);

            cs.execute();

            idPedido = cs.getInt(6);

        } catch (Exception e) {
            System.out.println("Error crearPedido: " + e.getMessage());
        } finally{
            cerrarRecursos();
        }

        return idPedido;
    }

    // Agregar detalle al pedido
    public boolean agregarDetalle(int idPedido,int idVariante,int cantidad) {
        cn = conexioncora_bd.probarConexion();
        try {

            cs =cn.prepareCall("{CALL sp_agregar_detalle_pedido(?,?,?)}");

            cs.setInt(1, idPedido);
            cs.setInt(2, idVariante);
            cs.setInt(3, cantidad);

            cs.execute();

            return true;

        } catch (Exception e) {

            System.out.println("Error agregarDetalle: " + e.getMessage());
            return false;
        }finally{
            cerrarRecursos();
        }
    }
    
    //Cambiar el estado al pedido, pasar de pendiente
    public boolean cambiarEstado(int idPedido,String estado,Date fechaMin,Date fechaMax) {
        cn = conexioncora_bd.probarConexion();
        try {

            cs = cn.prepareCall("{CALL sp_cambiar_estado_pedido(?,?,?,?)}");

            cs.setInt(1, idPedido);
            cs.setString(2, estado);
            cs.setDate(3, fechaMin);
            cs.setDate(4, fechaMax);

            cs.execute();

            return true;

        } catch (Exception e) {

            System.out.println("Error cambiarEstado: " + e.getMessage());
            return false;
        }finally{
            cerrarRecursos();
        }
    }
    
    // Anular pedido
    public boolean anularPedido(int idPedido) {
        cn = conexioncora_bd.probarConexion();
        try {

            cs = cn.prepareCall("{CALL sp_restaurar_stock_pedido(?)}");
            cs.setInt(1, idPedido);
            cs.execute();
            cs.close();

            cs = cn.prepareCall("{CALL sp_anular_pedido(?)}");
            cs.setInt(1, idPedido);
            cs.execute();

            return true;

        } catch (Exception e) {

            System.out.println("Error anularPedido: " + e.getMessage());
            return false;
        }finally{
            cerrarRecursos();
        }
    }
    
    public List<detallepedido> detallePedido(int idPedido) {

        List<detallepedido> lista = new ArrayList<>();
        cn = conexioncora_bd.probarConexion();
        try {

             cs = cn.prepareCall("{CALL sp_detalle_pedido(?)}");

            cs.setInt(1, idPedido);

            rs = cs.executeQuery();

            while (rs.next()) {

                detallepedido d = new detallepedido();

                d.setIdDetalle(rs.getInt("id_detalle"));
                d.setIdPedido(rs.getInt("id_pedido"));
                d.setIdVariante(rs.getInt("id_variante"));
                d.setNombreProducto(rs.getString("nombre"));
                d.setColor(rs.getString("color"));
                d.setTalla(rs.getString("talla"));
                d.setCantidad(rs.getInt("cantidad"));
                d.setPrecioUnitario(rs.getDouble("precio_unitario"));
                d.setSubtotal(rs.getDouble("subtotal"));
                
                lista.add(d);
            }

        } catch (Exception e) {

            System.out.println("Error detallePedido: " + e.getMessage());
        }finally {
            cerrarRecursos();
        }

        return lista;
    }
    
    
    //validar stock
    public boolean validarStock(int idVariante, int cantidad) {

        boolean disponible = false;
        cn = conexioncora_bd.probarConexion();
        try {

            cs = cn.prepareCall("{CALL sp_validar_stock(?,?)}");

            cs.setInt(1, idVariante);
            cs.setInt(2, cantidad);

            rs = cs.executeQuery();

            if (rs.next()) {
                disponible = rs.getInt("disponible") == 1;
            }

        } catch (Exception e) {

            System.out.println("Error validarStock: " + e.getMessage());

        } finally {
            cerrarRecursos();
        }

        return disponible;
    }
    //descontar stock
    
    public boolean descontarStock(int idVariante, int cantidad) {
        cn = conexioncora_bd.probarConexion();
        try {

            cs = cn.prepareCall("{CALL sp_descontar_stock(?,?)}");

            cs.setInt(1, idVariante);
            cs.setInt(2, cantidad);

            cs.execute();

            return true;

        } catch (Exception e) {

            System.out.println("Error descontarStock: " + e.getMessage());
            return false;

        } finally {
            cerrarRecursos();
        }
    }
    //obtener pedido
    public pedido obtenerPedido(int idPedido) {

        pedido p = null;
        cn = conexioncora_bd.probarConexion();
        try {

            cs = cn.prepareCall("{CALL sp_obtener_pedido(?)}");

            cs.setInt(1, idPedido);

            rs = cs.executeQuery();

            if (rs.next()) {

                p = new pedido();

                p.setId_pedido(rs.getInt("id_pedido"));
                p.setId_usuario(rs.getInt("id_usuario"));
                p.setFecha_pedido(rs.getString("fecha_pedido"));
                p.setTipo_entrega(rs.getString("tipo_entrega"));
                p.setCosto_delivery(rs.getDouble("costo_delivery"));
                p.setDireccion(rs.getString("direccion"));
                p.setMetodo_pago(rs.getString("metodo_pago"));
                p.setEstado(rs.getString("estado"));
                p.setNombreCompleto(rs.getString("nombre_completo"));
                p.setCorreo(rs.getString("correo"));
                p.setTelefono(rs.getString("telefono"));
                p.setFechaEntregaMin(rs.getDate("fecha_entrega_min"));
                p.setFechaEntregaMax(rs.getDate("fecha_entrega_max"));
            }

        } catch (Exception e) {

            System.out.println("Error obtenerPedido: " + e.getMessage());

        } finally {
            cerrarRecursos();
        }

        return p;
    }
    
    //obtener total
    public totalpedido obtenerTotal(int idPedido) {

        totalpedido t = null;
        cn = conexioncora_bd.probarConexion();
        try {

            cs = cn.prepareCall("{CALL sp_total_pedido(?)}");

            cs.setInt(1, idPedido);

            rs = cs.executeQuery();

            if (rs.next()) {

                t = new totalpedido();

                t.setSubtotal(rs.getDouble("subtotal"));
                t.setTotal(rs.getDouble("total"));
            }

        } catch (Exception e) {

            System.out.println("Error obtenerTotal: " + e.getMessage());

        } finally {
            cerrarRecursos();
        }

        return t;
    }
    
    //total de pedidos pendientes
    public List<pedido> listarPendientes() {

        List<pedido> lista = new ArrayList<>();
        cn = conexioncora_bd.probarConexion();
        try {

            cs = cn.prepareCall("{CALL sp_pedidos_pendientes()}");

            rs = cs.executeQuery();

            while (rs.next()) {

                pedido p = new pedido();

                p.setId_pedido(rs.getInt("id_pedido"));
                p.setId_usuario(rs.getInt("id_usuario"));
                p.setNombreCompleto(rs.getString("nombre_completo"));
                p.setFecha_pedido(rs.getString("fecha_pedido"));
                p.setTipo_entrega(rs.getString("tipo_entrega"));
                p.setCosto_delivery(rs.getDouble("costo_delivery"));
                p.setDireccion(rs.getString("direccion"));
                p.setMetodo_pago(rs.getString("metodo_pago"));
                p.setEstado(rs.getString("estado"));
                p.setFechaEntregaMin(rs.getDate("fecha_entrega_min"));
                p.setFechaEntregaMax(rs.getDate("fecha_entrega_max"));
                lista.add(p);
            }

        } catch (Exception e) {

            System.out.println("Error listarPendientes: " + e.getMessage());

        } finally {
            cerrarRecursos();
        }

        return lista;
    }
    
    //total de pedidos entregados 
    public List<pedido> listarEntregados() {

        List<pedido> lista = new ArrayList<>();
        cn = conexioncora_bd.probarConexion();
        try {

            cs = cn.prepareCall("{CALL sp_pedidos_entregados()}");

            rs = cs.executeQuery();

            while (rs.next()) {

                pedido p = new pedido();

                p.setId_pedido(rs.getInt("id_pedido"));
                p.setId_usuario(rs.getInt("id_usuario"));
                p.setNombreCompleto(rs.getString("nombre_completo"));
                p.setFecha_pedido(rs.getString("fecha_pedido"));
                p.setTipo_entrega(rs.getString("tipo_entrega"));
                p.setCosto_delivery(rs.getDouble("costo_delivery"));
                p.setDireccion(rs.getString("direccion"));
                p.setMetodo_pago(rs.getString("metodo_pago"));
                p.setEstado(rs.getString("estado"));
                p.setFechaEntregaMin(rs.getDate("fecha_entrega_min"));
                p.setFechaEntregaMax(rs.getDate("fecha_entrega_max"));
                lista.add(p);
            }

        } catch (Exception e) {

            System.out.println("Error listarEntregados: " + e.getMessage());

        } finally {
            cerrarRecursos();
        }

        return lista;
    }
    
    // Listar clientes para registrar pedido desde admin
    public List<usuarios> listarClientes() {

        List<usuarios> lista = new ArrayList<>();
        cn = conexioncora_bd.probarConexion();

        try {

            cs = cn.prepareCall("{CALL sp_clientes()}");

            rs = cs.executeQuery();

            while (rs.next()) {

                usuarios u = new usuarios();

                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setNombrecompleto(rs.getString("nombre_completo"));

                lista.add(u);
            }

        } catch (Exception e) {

            System.out.println("Error listarClientes: " + e.getMessage());

        } finally {
            cerrarRecursos();
        }

        return lista;
    }
    // Listar variantes disponibles para registrar pedido desde admin
    public List<productos> listarVariantesDisponibles() {

        List<productos> lista = new ArrayList<>();
        cn = conexioncora_bd.probarConexion();

        try {

            cs = cn.prepareCall("{CALL sp_variantes_disponibles()}");

            rs = cs.executeQuery();

            while (rs.next()) {

                productos pv = new productos();
                pv.setId_producto(rs.getInt("id_producto"));
                pv.setId_variante(rs.getInt("id_variante"));
                pv.setNombre_producto(rs.getString("nombre"));
                pv.setColor(rs.getString("color"));
                pv.setTalla(rs.getString("talla"));
                pv.setStock(rs.getInt("stock"));
                pv.setPrecio(rs.getDouble("precio"));

                lista.add(pv);
            }

        } catch (Exception e) {

            System.out.println("Error listarVariantesDisponibles: " + e.getMessage());

        } finally {
            cerrarRecursos();
        }

        return lista;
    }
    
    public boolean actualizarCostoDelivery(int idPedido, double costoDelivery) {
        boolean actualizado = false;
        String sql = "{CALL sp_actualizar_costo_delivery(?, ?)}";

        try {
            cn = conexioncora_bd.probarConexion();
            cs = cn.prepareCall(sql);
            cs.setInt(1, idPedido);
            cs.setDouble(2, costoDelivery);

            int filas = cs.executeUpdate();
            actualizado = filas > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cs != null) cs.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return actualizado;
    }
    
    private void cerrarRecursos() {
        try {
            if (rs != null) rs.close();
            if (cs != null)  cs.close();
            if (ps != null)  ps.close();
            if (cn != null) cn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}