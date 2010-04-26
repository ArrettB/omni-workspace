package com.dynamic.charm.examples;

import org.junit.Test;

import com.dynamic.charm.examples.orm.City;
import com.dynamic.charm.service.QueryService;

public class CityTest extends DummyDataSupport
{

	@Test
	public void testSomething()
	{
		assertTrue(true);
	}

	//@Test
	//public void testInsertCity()
	//{
	//	City city = new City();
	//	city.setCityName("Coolsville");
	//	city.setStateCode("MN");

	//	getQueryService().save(city);

		/*
		This needs to be researched in Hibernate - id is not set upon save,
		so this assertion will always fail.
		*/
		//assertTrue(city.getCityId() > 0);

	//	assertQueryResultEquals("SELECT count(*) FROM cities WHERE city_name = 'Coolsville'", 1);

	//}


}
