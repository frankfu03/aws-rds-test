package au.gov.ga.geodesy.archive;

import static org.assertj.core.api.Assertions.assertThat;
import org.testng.annotations.Test;

import au.gov.ga.geodesy.archive.support.auroradb.AuroraDbRinexFileIndex;

public class AuroraDBLocalTest {

    private String HOSTNAME = "geodesy-archive-aurora-postgresql-dev2.cluster-c76tte2hbd9p.ap-southeast-2.rds.amazonaws.com:5432/rinex-file-index";
    private String USER_NAME = "indexadmin";
    private String PASSWORD = "index"; // "gagnssrds20190110";
    private int PORT = 5432;

    @Test
    public void testCreateAuroraDbTable() {
        try {
            AuroraDbRinexFileIndex auroraDb = new AuroraDbRinexFileIndex();
            auroraDb.find();
        } catch (Exception e) {
            e.printStackTrace();
        }

        //assertThat().isEqualTo("");
    }

    //@Test
//    public void testIamDbAuth() {
//        IAMDatabaseAuthenticationTester iam = new IAMDatabaseAuthenticationTester();
//        iam.runQuery();
//    }

    //@Test
//    public void testCreateTable() {
//        IAMDatabaseAuthenticationTester iam = new IAMDatabaseAuthenticationTester();
//        iam.createRinexFileIndexTable();
//    }
}
