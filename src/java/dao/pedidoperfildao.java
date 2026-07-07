package dao;

import conexion.conexioncora_bd;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class pedidoperfildao {

    private Connection cn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    public int obtenerTotalPedidosCliente(int idUsuario) {
        int total = 0;
        try {
            cn = conexioncora_bd.probarConexion();
            String sql = "SELECT COUNT(*) AS total FROM pedidos WHERE id_usuario = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrarRecursos();
        }
        return total;
    }

    public int obtenerPedidosPendientesCliente(int idUsuario) {
        int total = 0;
        try {
            cn = conexioncora_bd.probarConexion();
            String sql = "SELECT COUNT(*) AS total FROM pedidos WHERE id_usuario = ? AND LOWER(estado) = 'pendiente'";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrarRecursos();
        }
        return total;
    }

    public int obtenerPedidosCursoCliente(int idUsuario) {
        int total = 0;
        try {
            cn = conexioncora_bd.probarConexion();
            String sql = "SELECT COUNT(*) AS total FROM pedidos WHERE id_usuario = ? AND LOWER(estado) = 'curso'";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrarRecursos();
        }
        return total;
    }

    public int obtenerPedidosEntregadosCliente(int idUsuario) {
        int total = 0;
        try {
            cn = conexioncora_bd.probarConexion();
            String sql = "SELECT COUNT(*) AS total FROM pedidos WHERE id_usuario = ? AND LOWER(estado) = 'entregado'";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrarRecursos();
        }
        return total;
    }

    public String obtenerUltimoPedidoCliente(int idUsuario) {
        String ultimo = "";
        try {
            cn = conexioncora_bd.probarConexion();
            String sql = "SELECT id_pedido FROM pedidos WHERE id_usuario = ? ORDER BY id_pedido DESC LIMIT 1";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            if (rs.next()) {
                ultimo = "#" + rs.getInt("id_pedido");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrarRecursos();
        }
        return ultimo;
    }

    public String obtenerMetodoFavoritoCliente(int idUsuario) {
        String metodo = "";
        try {
            cn = conexioncora_bd.probarConexion();
            String sql = "SELECT metodo_pago, COUNT(*) AS cantidad " +
                         "FROM pedidos " +
                         "WHERE id_usuario = ? " +
                         "GROUP BY metodo_pago " +
                         "ORDER BY cantidad DESC " +
                         "LIMIT 1";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            if (rs.next()) {
                metodo = rs.getString("metodo_pago");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrarRecursos();
        }
        return metodo;
    }

    public String obtenerTipoEntregaFavoritoCliente(int idUsuario) {
        String tipo = "";
        try {
            cn = conexioncora_bd.probarConexion();
            String sql = "SELECT tipo_entrega, COUNT(*) AS cantidad " +
                         "FROM pedidos " +
                         "WHERE id_usuario = ? " +
                         "GROUP BY tipo_entrega " +
                         "ORDER BY cantidad DESC " +
                         "LIMIT 1";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            if (rs.next()) {
                tipo = rs.getString("tipo_entrega");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cerrarRecursos();
        }
        return tipo;
    }

    public List<String> obtenerNombresProductosMasComprados(int idUsuario) {
        List<String> nombres = new ArrayList<>();
        try {
            cn = conexioncora_bd.probarConexion();

            String sql = "SELECT pr.nombre, SUM(dp.cantidad) AS total " +
                         "FROM pedidos p " +
                         "INNER JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido " +
                         "INNER JOIN producto_variantes pv ON dp.id_variante = pv.id_variante " +
                         "INNER JOIN productos pr ON pv.id_producto = pr.id_producto " +
                         "WHERE p.id_usuario = ? " +
                         "GROUP BY pr.id_producto, pr.nombre " +
                         "ORDER BY total DESC " +
                         "LIMIT 5";

            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();

            while (rs.next()) {
                nombres.add(rs.getString("nombre"));
            }

        } catch (Exception e) {
            System.out.println("Error obtenerNombresProductosMasComprados: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos();
        }
        return nombres;
    }

    public List<Integer> obtenerCantidadesProductosMasComprados(int idUsuario) {
        List<Integer> cantidades = new ArrayList<>();
        try {
            cn = conexioncora_bd.probarConexion();

            String sql = "SELECT pr.nombre, SUM(dp.cantidad) AS total " +
                         "FROM pedidos p " +
                         "INNER JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido " +
                         "INNER JOIN producto_variantes pv ON dp.id_variante = pv.id_variante " +
                         "INNER JOIN productos pr ON pv.id_producto = pr.id_producto " +
                         "WHERE p.id_usuario = ? " +
                         "GROUP BY pr.id_producto, pr.nombre " +
                         "ORDER BY total DESC " +
                         "LIMIT 5";

            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();

            while (rs.next()) {
                cantidades.add(rs.getInt("total"));
            }

        } catch (Exception e) {
            System.out.println("Error obtenerCantidadesProductosMasComprados: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos();
        }
        return cantidades;
    }

    private void cerrarRecursos() {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try {
            if (cn != null) {
                cn.setAutoCommit(true);
                cn.close();
            }
        } catch (Exception e) {}
    }
}