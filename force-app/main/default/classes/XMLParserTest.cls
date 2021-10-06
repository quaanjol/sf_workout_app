@isTest
private class XMLParserTest {
    @isTest static void parseTest1() {
        string xml = '<?xml version="1.0" encoding="UTF-8"?><breakfast_menu><food><name>Belgian Waffles</name><price>$5.95</price><description>Two of our famous Belgian Waffles with plenty of real maple syrup</description><calories>650</calories></food><food><name>Strawberry Belgian Waffles</name><price>$7.95</price><description>Light Belgian waffles covered with strawberries and whipped cream</description><calories>900</calories></food><food><name>Berry-Berry Belgian Waffles</name><price>$8.95</price><description>Light Belgian waffles covered with an assortment of fresh berries and whipped cream</description><calories>900</calories></food><food><name>French Toast</name><price>$4.50</price><description>Thick slices made from our homemade sourdough bread</description><calories>600</calories></food><food><name>Homestyle Breakfast</name><price>$6.95</price><description>Two eggs, bacon or sausage, toast, and our ever-popular hash browns</description><calories>950</calories></food></breakfast_menu>';
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        Dom.XMLNode root = doc.getRootElement();
        
        string json = XMLParser.parse(root, false);
        string expected = '{"breakfast_menu" :  {"food": [{"name": "Belgian Waffles", "price": "$5.95", "description": "Two of our famous Belgian Waffles with plenty of real maple syrup", "calories": "650"}, {"name": "Strawberry Belgian Waffles", "price": "$7.95", "description": "Light Belgian waffles covered with strawberries and whipped cream", "calories": "900"}, {"name": "Berry-Berry Belgian Waffles", "price": "$8.95", "description": "Light Belgian waffles covered with an assortment of fresh berries and whipped cream", "calories": "900"}, {"name": "French Toast", "price": "$4.50", "description": "Thick slices made from our homemade sourdough bread", "calories": "600"}, {"name": "Homestyle Breakfast", "price": "$6.95", "description": "Two eggs, bacon or sausage, toast, and our ever-popular hash browns", "calories": "950"}]}}';
        system.debug(json);
        system.assertEquals(expected, json);
    }
    
    @isTest static void xmlToJsonTest1() {
        string xml = '<?xml version="1.0" encoding="UTF-8"?><breakfast_menu><food><name>Belgian Waffles</name><price>$5.95</price><description>Two of our famous Belgian Waffles with plenty of real maple syrup</description><calories>650</calories></food><food><name>Strawberry Belgian Waffles</name><price>$7.95</price><description>Light Belgian waffles covered with strawberries and whipped cream</description><calories>900</calories></food><food><name>Berry-Berry Belgian Waffles</name><price>$8.95</price><description>Light Belgian waffles covered with an assortment of fresh berries and whipped cream</description><calories>900</calories></food><food><name>French Toast</name><price>$4.50</price><description>Thick slices made from our homemade sourdough bread</description><calories>600</calories></food><food><name>Homestyle Breakfast</name><price>$6.95</price><description>Two eggs, bacon or sausage, toast, and our ever-popular hash browns</description><calories>950</calories></food></breakfast_menu>';
        
        string json = XMLParser.xmlToJson(xml);
        string expected = '{"breakfast_menu" :  {"food": [{"name": "Belgian Waffles", "price": "$5.95", "description": "Two of our famous Belgian Waffles with plenty of real maple syrup", "calories": "650"}, {"name": "Strawberry Belgian Waffles", "price": "$7.95", "description": "Light Belgian waffles covered with strawberries and whipped cream", "calories": "900"}, {"name": "Berry-Berry Belgian Waffles", "price": "$8.95", "description": "Light Belgian waffles covered with an assortment of fresh berries and whipped cream", "calories": "900"}, {"name": "French Toast", "price": "$4.50", "description": "Thick slices made from our homemade sourdough bread", "calories": "600"}, {"name": "Homestyle Breakfast", "price": "$6.95", "description": "Two eggs, bacon or sausage, toast, and our ever-popular hash browns", "calories": "950"}]}}';
        system.debug(json);
        system.assertEquals(expected, json);
    }
}