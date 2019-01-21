package au.gov.ga.geodesy.archive.support.auroradb;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;
import java.util.Calendar;

import java.text.ParseException;
import java.text.SimpleDateFormat;

public class AuroraDbRinexFileIndex {

    public final static String HOSTNAME = "geodesy-archive-aurora-postgresql-dev2.cluster-c76tte2hbd9p.ap-southeast-2.rds.amazonaws.com";
    public final static String PORT = "5432";
    public final static String DB_NAME = "rinex_file_index";
    public final static String USER_NAME = "indexadmin";
    public final static String PASSWORD = "index";
    public final static String TABLE_NAME="rinex_file_index";
    public final static String SCHEMA="rinex_file_index";

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

    public void insert(String rinexFileId, String stationId, String rinexVersion, String status, String fileType, String filePeriod, String dateString, String fileLocation, int eventNumber, String isPublic) throws SQLException, ParseException {
        PreparedStatement statement = connection.prepareStatement("INSERT INTO "+TABLE_NAME+" VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        int count = 1;
        statement.setString(count ++, rinexFileId);
        statement.setString(count ++, stationId);
        statement.setString(count ++, rinexVersion);
        statement.setString(count ++, status);
        statement.setString(count ++, fileType);
        statement.setString(count ++, filePeriod);
        statement.setDate(count ++, getDate(dateString));
        statement.setString(count ++, fileLocation);
        statement.setInt(count ++, eventNumber);
        statement.setString(count ++, isPublic);
        statement.executeUpdate();
        statement.close();
    }

    public int selectAll() throws SQLException {
        String sql = "SELECT * FROM " + TABLE_NAME;
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(sql);
        int count = 0;
        while (resultSet.next()) {
            //String id = resultSet.getString("rinexFileId");
            count ++;
        }
        System.out.println("Total Records: " + count);
        return count;
    }

    public int selectBy(String stationId) throws SQLException {
        String sql = "SELECT * FROM " + TABLE_NAME + " where "+SCHEMA+".StationId=ALIC";
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(sql);
        int count = 0;
        while (resultSet.next()) {
            //String id = resultSet.getString("rinexFileId");
            count ++;
        }
        System.out.println("Total Records: " + count);
        return count;
    }

    private java.sql.Date getDate(String dateString) throws ParseException{
        SimpleDateFormat sdf = new SimpleDateFormat("yyyymmdd'T'hh:mm:ss'Z'");
        java.util.Date date = sdf.parse(dateString);
        return new Date(date.getTime());
    }
}
