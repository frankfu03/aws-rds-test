package au.gov.ga.geodesy.archive;

import static org.assertj.core.api.Assertions.assertThat;
import org.testng.annotations.Test;

import java.util.Date;
import java.util.UUID;

import au.gov.ga.geodesy.archive.support.auroradb.AuroraDbRinexFileIndex;

public class AuroraDBLocalTest {

    String[] stations = {"ALIC", "BAKE", "BALA", "COCO", "DORR", "FOMO", "KELY", "LONA", "MEDO", "SYDN"};
    String[] statusArray = {"metadata_valid", "metadata_invalid"};
    String[] rinexVersions = {"rinex_2", "rinex_3"};
    String[] fileTypes = {"obs", "met", "nav"};
    String[] filePeriods = {"01H", "01D", "15M"};

    @Test
    public void testInsertValue() {

        String rinexFileId = UUID.randomUUID().toString();
        String stationId = getRandomItem(stations);
        String rinexVersion = getRandomItem(rinexVersions);
        String status = getRandomItem(statusArray);
        String fileType = getRandomItem(fileTypes);;
        String filePeriod = getRandomItem(filePeriods);
        String startDate = "20190118T08:35:00Z";
        String fileLocation = "C://downloads";
        int eventNumber = 8;
        String isPublic = "Y";
        try {
            AuroraDbRinexFileIndex auroraDb = new AuroraDbRinexFileIndex();
            int count1 = auroraDb.selectAll();
            auroraDb.insert(rinexFileId, stationId, rinexVersion, status, fileType, filePeriod, startDate, fileLocation, eventNumber, isPublic);
            int count2 = auroraDb.selectAll();
            assertThat(count2).isEqualTo(count1 + 1);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void testSelectAll() {
        try {
            AuroraDbRinexFileIndex auroraDb = new AuroraDbRinexFileIndex();
            int count = auroraDb.selectAll();
            assertThat(count).isGreaterThanOrEqualTo(5);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String getRandomItem(String[] stringArray) {
        int randomItemNo = getRandomInt() % stringArray.length;
        return stringArray[randomItemNo];
    }
    private int getRandomInt() {
        return (int)(Math.random() * 100);
    }
}
