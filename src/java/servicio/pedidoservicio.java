package servicio;

import conexion.conexioncora_bd;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.List;
import modelo.ItemCarrito;

public class pedidoservicio {

    public boolean registrarPedidoCompleto(int idUsuario, String tipoEntrega, double costoDelivery,String direccion, String metodoPago, List<ItemCarrito> carrito) {

        Connection conexion = null;

        try {

            conexion = conexioncora_bd.probarConexion();

            conexion.setAutoCommit(false);

            // Validar stock
            for (ItemCarrito item : carrito) {

                CallableStatement cs =
                        conexion.prepareCall("{CALL sp_validar_stock(?,?)}");

                cs.setInt(1, item.getIdVariante());
                cs.setInt(2, item.getCantidad());

                ResultSet rs = cs.executeQuery();

                if (rs.next() && rs.getInt("disponible") == 0) {

                    conexion.rollback();

                    rs.close();
                    cs.close();

                    return false;
                }

                rs.close();
                cs.close();
            }

            // Crear pedido
            CallableStatement csPedido =
                    conexion.prepareCall("{CALL sp_crear_pedido(?,?,?,?,?,?)}");

            csPedido.setInt(1, idUsuario);
            csPedido.setString(2, tipoEntrega);
            csPedido.setDouble(3, costoDelivery);
            csPedido.setString(4, direccion);
            csPedido.setString(5, metodoPago);

            csPedido.registerOutParameter(6, Types.INTEGER);

            csPedido.execute();

            int idPedido = csPedido.getInt(6);

            csPedido.close();

            // Registrar detalles
            for (ItemCarrito item : carrito) {

                CallableStatement csDetalle =
                        conexion.prepareCall("{CALL sp_agregar_detalle_pedido(?,?,?)}");

                csDetalle.setInt(1, idPedido);
                csDetalle.setInt(2, item.getIdVariante());
                csDetalle.setInt(3, item.getCantidad());

                csDetalle.execute();

                csDetalle.close();

                CallableStatement csStock =
                        conexion.prepareCall("{CALL sp_descontar_stock(?,?)}");

                csStock.setInt(1, item.getIdVariante());
                csStock.setInt(2, item.getCantidad());

                csStock.execute();

                csStock.close();
            }

            conexion.commit();

            return true;

        } catch (Exception e) {

            try {

                if (conexion != null) {
                    conexion.rollback();
                }

            } catch (SQLException ex) {
                ex.printStackTrace();
            }

            System.out.println("Error registrarPedidoCompleto: " + e.getMessage());

            return false;

        } finally {

            try {

                if (conexion != null) {
                    conexion.setAutoCommit(true);
                    conexion.close();
                }

            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public int registrarPedidoCompletoConId(int idUsuario, String tipoEntrega, double costoDelivery, String direccion, String metodoPago, java.sql.Date fechaMin, java.sql.Date fechaMax, List<ItemCarrito> carrito) {
        Connection conexion = null;
        try {
            conexion = conexioncora_bd.probarConexion();
            conexion.setAutoCommit(false);

            // Validar stock
            for (ItemCarrito item : carrito) {
                CallableStatement cs = conexion.prepareCall("{CALL sp_validar_stock(?,?)}");
                cs.setInt(1, item.getIdVariante());
                cs.setInt(2, item.getCantidad());
                ResultSet rs = cs.executeQuery();
                if (rs.next() && rs.getInt("disponible") == 0) {
                    conexion.rollback();
                    rs.close();
                    cs.close();
                    return -1;
                }
                rs.close();
                cs.close();
            }

            // Crear pedido
            CallableStatement csPedido = conexion.prepareCall("{CALL sp_crear_pedido(?,?,?,?,?,?)}");
            csPedido.setInt(1, idUsuario);
            csPedido.setString(2, tipoEntrega);
            csPedido.setDouble(3, costoDelivery);
            csPedido.setString(4, direccion);
            csPedido.setString(5, metodoPago);
            csPedido.registerOutParameter(6, Types.INTEGER);
            csPedido.execute();
            int idPedido = csPedido.getInt(6);
            csPedido.close();

            if (fechaMin != null && fechaMax != null) {
                CallableStatement csDates = conexion.prepareCall("{CALL sp_cambiar_estado_pedido(?,?,?,?)}");
                csDates.setInt(1, idPedido);
                csDates.setString(2, "pendiente"); 
                csDates.setDate(3, fechaMin);
                csDates.setDate(4, fechaMax);
                csDates.execute();
                csDates.close();
            }

            // Registrar detalles
            for (ItemCarrito item : carrito) {
                CallableStatement csDetalle = conexion.prepareCall("{CALL sp_agregar_detalle_pedido(?,?,?)}");
                csDetalle.setInt(1, idPedido);
                csDetalle.setInt(2, item.getIdVariante());
                csDetalle.setInt(3, item.getCantidad());
                csDetalle.execute();
                csDetalle.close();

                CallableStatement csStock = conexion.prepareCall("{CALL sp_descontar_stock(?,?)}");
                csStock.setInt(1, item.getIdVariante());
                csStock.setInt(2, item.getCantidad());
                csStock.execute();
                csStock.close();
            }

            conexion.commit();
            return idPedido;

        } catch (Exception e) {
            try {
                if (conexion != null) {
                    conexion.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.out.println("Error registrarPedidoCompletoConId: " + e.getMessage());
            return -1;
        } finally {
            try {
                if (conexion != null) {
                    conexion.setAutoCommit(true);
                    conexion.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}