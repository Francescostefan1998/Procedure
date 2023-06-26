package callProcedureMain;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Main {

	public static void main(String[] args) {
		 String url = "jdbc:mysql://localhost:3306/test";
	        String user = "root";
	        String password = "#Marconato1998";

	        try {
	            Class.forName("com.mysql.cj.jdbc.Driver");
	        } catch (ClassNotFoundException e) {
	            e.printStackTrace();
	            return;
	        }

	        try (Connection conn = DriverManager.getConnection(url, user, password)) {
	            String query = "{CALL get_age_autori_nazione1(?)}";
	            CallableStatement stmt = conn.prepareCall(query);
	            
	          stmt.setString(1, "Italia");
	            stmt.execute();

	            Statement selectStmt = conn.createStatement();
	            ResultSet rs = selectStmt.executeQuery("SELECT * FROM autori_eta_temp");

	            List<String> authors = new ArrayList<>();

	            while (rs.next()) {
	                String nome = rs.getString("nome");
	                String cognome = rs.getString("cognome");
	                int eta = rs.getInt("eta");
	                authors.add("Nome: " + nome + ", Cognome: " + cognome + ", Eta: " + eta);
	            }

	            
	            for (String author : authors) {
	                System.out.println(author);
	            }
	        } catch (SQLException ex) {
	            ex.printStackTrace();
	        }
	}

}
