package au.gov.ga.geodesy.archive.support.auroradb;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

public class AuroraDbRinexFileIndex {

    public final static String HOSTNAME = "geodesy-archive-aurora-postgresql-dev2.cluster-c76tte2hbd9p.ap-southeast-2.rds.amazonaws.com";
    public final static String PORT = "5432";
    public final static String DB_NAME = "rinex-file-index";
    public final static String USER_NAME = "indexadmin";
    public final static String PASSWORD = "index";
    public final static String TABLE_NAME="rinex_file_index";

    public Connection connection;


    public AuroraDbRinexFileIndex() throws Exception{
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        try {
            connection = getConnection();
            System.out.println("~~~~ JDBC connection is done!");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new Exception("JDBC Connection is null");
        }
    }

    public Connection getConnection() throws SQLException {
        String connectionString = String.format("jdbc:postgresql://%s:%s/%s", HOSTNAME, PORT, DB_NAME);
        System.out.println("~~~~ JDBC Connection String="+connectionString);
        Connection conn = DriverManager.getConnection(connectionString, USER_NAME, PASSWORD);

        return conn;
    }

    public void insert() throws SQLException {
        PreparedStatement statement = connection.prepareStatement("INSERT INTO "+TABLE_NAME+" (content) VALUES (?)");
        String content = "";
        statement.setString(1, content);
        statement.executeUpdate();
    }

    public void find() throws SQLException {
        String sql = "SELECT * FROM " + TABLE_NAME + " where StationId=ALIC";
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(sql);
        int count = 0;
        while (resultSet.next()) {
            //String id = resultSet.getString("rinexFileId");
            count ++;
        }
        System.out.println("Total Records: " + count);
    }
}
