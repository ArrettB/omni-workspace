package com.dynamic.servicetrax.service;

import com.dynamic.servicetrax.orm.Address;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * User: pgarvie
 * Date: Nov 7, 2010
 * Time: 7:53:43 PM
 */
public class HotSheetServiceUtils {

    private static final HotSheetServiceUtils INSTANCE = new HotSheetServiceUtils();
    private static JdbcTemplate jdbcTemplate;

    public static HotSheetServiceUtils getInstance() {
        return INSTANCE;
    }

    public static final String SELECT_ADDRESS =
            "SELECT JOB_LOCATION_ID, JOB_LOCATION_NAME, STREET1, STREET2, STREET3, CITY, " +
                    "STATE, ZIP, COUNTRY FROM JOB_LOCATIONS WHERE JOB_LOCATION_ID = ? ";

    public Address getAddress(BigDecimal jobLocationId) {


        Address address = (Address) jdbcTemplate.queryForObject(SELECT_ADDRESS,
                                                                new Object[]{jobLocationId},
                                                                new AddressMapper());
        if (address == null) {
            return null;
        }

        return address;
    }

    public List<Address> convertToAddressList(List<Map> originAddresses) {
        List<Address> addresses = new ArrayList<Address>();
        for (Map aRow : originAddresses) {
            Address anAddress = new Address();
            BigDecimal id = (BigDecimal) aRow.get("JOB_LOCATION_ID");
            anAddress.setJobLocationId(id.longValue());
            anAddress.setJobLocationName((String) aRow.get("JOB_LOCATION_NAME"));
            anAddress.setStreetOne((String) aRow.get("STREET1"));
            anAddress.setStreetTwo((String) aRow.get("STREET2"));
            anAddress.setStreetThree((String) aRow.get("STREET3"));
            anAddress.setCity((String) aRow.get("CITY"));
            anAddress.setState((String) aRow.get("STATE"));
            anAddress.setZip((String) aRow.get("ZIP"));
            anAddress.setCountry((String) aRow.get("COUNTRY"));
            addresses.add(anAddress);
        }
        return addresses;
    }

    public String getValue(Object param) {
        String[] s = (String[]) param;
        if (s != null && s.length > 0) {
            return s[0];
        }
        return null;
    }

    public void setJdbcTemplate(JdbcTemplate initJdbcTemplate) {
        jdbcTemplate = initJdbcTemplate;
    }


    private class AddressMapper implements RowMapper {

        public Object mapRow(ResultSet resultSet, int i) throws SQLException {
            Address address = new Address();
            address.setJobLocationId(resultSet.getLong("JOB_LOCATION_ID"));
            address.setJobLocationName(resultSet.getString("JOB_LOCATION_NAME"));
            address.setStreetOne(resultSet.getString("STREET1"));
            address.setStreetTwo(resultSet.getString("STREET2"));
            address.setStreetThree(resultSet.getString("STREET3"));
            address.setCity(resultSet.getString("CITY"));
            address.setState(resultSet.getString("STATE"));
            address.setZip(resultSet.getString("ZIP"));
            address.setCountry(resultSet.getString("COUNTRY"));
            return address;
        }
    }


    //TODO: move these into a db table - pfg 11.14.10
    public static final String EQUIPMENT_VACUUMS = "Vacuums";
    public static final String EQUIPMENT_CLEANING_KITS = "Cleaning Kits";
    public static final List<String> EQUIPMENT =
            Arrays.asList("",
                          "Autobottoms",
                          "Big Reds",
                          "Blue Tape",
                          "Boards Long",
                          "Boards Short",
                          "Carts Library",
                          "Carts Machine",
                          EQUIPMENT_CLEANING_KITS,
                          "Cornerboards",
                          "Dollies",
                          "J-Bars",
                          "Labels Black",
                          "Labels Blue",
                          "Labels Brown ",
                          "Labels Green",
                          "Labels Pink",
                          "Labels Purple",
                          "Labels Orange",
                          "Labels Red",
                          "Labels Yellow",
                          "Masonite Half",
                          "Masonite Full",
                          "Mollies/Toggles",
                          "Pallet Jacks",
                          "Panel Carts",
                          "PR Cartons",
                          "Safe Equipment",
                          "Safe Jacks",
                          "Shrinkwrap",
                          "Tote Stacks",
                          "Trucks Hand",
                          "Trucks Reefer",
                          EQUIPMENT_VACUUMS);


    private HotSheetServiceUtils() {
    }
}
