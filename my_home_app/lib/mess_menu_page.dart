import 'package:flutter/material.dart';

// Data class for a single mess menu item
class MessDayMenu {
  final String dayAndDates;
  final List<String> breakfast;
  final List<String> lunch;
  final List<String> snacks;
  final List<String> dinner;

  MessDayMenu({
    required this.dayAndDates,
    required this.breakfast,
    required this.lunch,
    required this.snacks,
    required this.dinner,
  });
}

class MessMenuPage extends StatelessWidget {
  const MessMenuPage({super.key});

  // Raw mess menu data provided by the user
  final String _messMenuRawData = '''
NOTE: 
1) Thick curd must be served as per the menu, either during Lunch or Dinner.
2) Fresh salad must be served every day as per the menu.
3) Toaster should be kept functional every day.
4) A weighing machine must be used while serving Chicken and Paneer.
5) Chicken should weigh 150g (and 180g on Sundays) after cooking, i.e., before serving (excluding bowl weight and gravy).
6) Paneer should be soft and weigh 70g after cooking, i.e., before serving (excluding bowl weight and gravy).
7) Roti/Phulka/Chapathi should be prepared using 100% good quality Atta.
8) White Rice (Sonamasuri) must be cooked properly every day (neither undercooked nor overcooked).                                    
9) All wet gravy based curries should be prepared with 75% vegetables and 25% gravy

VIT-AP UNIVERSITY HOSTELS, AMARAVATI
VEG AND NON VEG MESS MENU FOR THE MONTH OF - OCTOBER- 2025
Dates	Breakfast	Lunch	Snacks	Dinner
Mon        13,27	Chole Bhature 3 Pcs Medium Size	Carrot Salad	Masala Sweet Corn	Cucumber Salad, Onions
	Veg pongal	Phulka	Cold Badam Milk	Roti
	Ground nut Chutney	White Rice		White Rice
	Milk Bread + Butter + Jam	Ladies finger poriyal with coconut (Bendi poriyal)		Pudina Rice
	Milk, Tea, Coffee Powder	Andhra Style Muddha Pappu + Avakaya		Chilli Paneer Semi Gravy / Andhra Style Chicken Fry
	Boiled Egg	Kadai Veg		Dal Tadka
	Sprouts (1 cup)	 Sambar		Tomato Rasam
		Papad		Thick Curd
		 Butter milk		Red Chilli Pickle
		Potlakaya Chutney, Ghee + Podi		Banana
		Rabdi		Milk
				Coffee Powder




Tue             14,28		Beetroot & Cucumber Salad	Aloo Samosa, Imli Chutney	Carrot Salad
	Masala Dosa,Vada pav	Chapathi	Ginger Tea	Phulka
	Sambar, Coconut Chutney 	Bisibele bath	 Coffee	White Rice
	Brown Bread + Butter + Jam	White Rice		Veg Noodles, Tomato Sauce
	Coffee Powder,Tea, Milk	Carrot Beans Poriyal		Veg Kurma (Veg) / Egg Bhurji (NV)
	Sprouts (1 cup)	Rajma Masala		Pesara Pappu
		Amaranthus Dal (Thotakura Pappu)		Thick Curd
		Curd Vada		Tomato Pickle
		Potato Chips		Pine Apple Fruit 
		Tomato chutney, Ghee + Podi		Milk
				Coffee Powder




Wed    1,15,29	Pongal	Onions & Cucumber Salad	Mirchi Bhajji ( 2 pcs), Onions	Beetroot Salad
	Methu Vada (3 pcs Medium Size)	Roti	Ground Nut chutney	Chapathi
	Coconut chutney	Bhagara rice	Ginger Tea, Coffee	White Rice
	Milk Bread + Butter + Jam	White Rice		Carrot Rice
	Tea, Coffee Powder, Milk	 Andhra Style Chicken curry		Lauki Channa Masala
	Masala Omlet	Panneer Butter Masala 		Tomato Dal
	Sprouts (1 cup)	Dal Makhani		Sambar
		Beetroot Tomato Rasam		Thick Curd
		Butter Milk		Mango Pickle
		Onion Rings Fryums		Fruit Custard (Minimum 4 Types Fruits)
		Vankaya (Brinjal) Chutney, Ghee + Podi		Milk
		Gulab Jamun		Coffee Powder




Thu        2,16,30	Poori	Boiled Chana with Onion & Tomato	Papdi Chat	Carrot Salad
	Semiya Upma	Phulka	Tea, Coffee	Roti
	Besan Mix Veg Chutney	Lemon rice		White Rice
	Brown Bread + Butter + Jam	White Rice		Schezwan Fried Rice,Tomato Sauce
	Tea,Coffee Powder,Milk	Veg do Pyaza		Gobi Manchurian(3ps)
	Scrambled Egg 	Dondakaya Poriyal		Dal Punjabi
	Sprouts (1 cup)	Beerakaya pappu		Sambar
		Majiga Pulusu		Thick Curd 
		Lemonade with Sabja Seeds		 Lemon Pickle
		Fryums		Water Melon Fruit
		Vankaya (Brinjal) Chutney, Ghee + Podi		Milk
				Coffee Powder





Fri         3,17,31	Mysore Bonda (3 pcs)	Beetroot Salad	Sambar Vada 2 nos	Cucumber Salad & Onions
	Tomato Upma	Chapathi	Ginger Tea, Coffee	Lacha paratha(2pcs standard size)
	Coconut Chutney, Sambar	Mix Veg Pulav		White Rice
	Milk bread + Butter + Jam	White Rice		Chetinad Chicken Curry / Kadai paneer curry
	Tea, Coffee Powder, Milk	Raw Banana Fry		Sambar
	Boiled egg	Brinjal kara Curry (Ennai kaththirikkai)		Rasam
	Sprouts (1 cup)	 Dal Maharani		Thick Curd
		Rasam		Tomato Pickle
		Lassi		Fruit Custard (Minimum 4 Types Fruits)
		Fryums		Milk
		Fresh Coriander Tomato Chutney, Ghee + Podi		Coffee Powder
		Jilebi






Sat            4,18	 Mix Veg Uthappam (2Pcs) Standard Size	Carrot & Cucumber Salad	Onion Samosa (3 pcs regular)	Beetroot Salad
	Uggani	Roti	 Tea, Coffee	Chapathi
	Coconut Chutney	Tomato Rice	Sauce	White Rice
	Brown Bread + Butter + Jam	White Rice		Veg Pasta, Sauce
	Tea, Coffee Powder, Milk	Aloo deep Fry		Cabbage Deep Fry {65 style},
	Masala Omlet	Beerakaya Tomato Curry		Dal Maharani
	Sprouts (1 cup)	Mango Dal		Sambar
		Rasam		Thick Curd
		Butter milk		Red Chilli Pickle
		Papad		Muskmelon
		Gongura Chutney, Ghee + Podi		Milk
				Coffee Powder





Sun         5,19	Aloo Paratha (2 Pcs medium size)	Carrot Salad & Onions	Pani Poori,Onions	Cucumber Salad
	Wheat upma	Phulka	Masala Tea, Coffee	Roti
	Mango Pickle, Groundnut Chutney, Curd	Chicken Dum Biryani (NV) /Paneer Dum Vegetable Biryani (VEG)		White Rice
	Milk Bread + Butter + Jam	White Rice		Onion Uttappam,Groundnut Chutney
	Coffee Powder,Milk	 Gravy (Chicken GRAVY (NV) /  Hyderabadi Mirchi Ka Salan (VEG), Onion Raitha		Dal Makhani
	Scrambled Egg 	Punjabi Dal Fry		Sambar
	Sprouts (1 cup)	Rasam		Thick Curd 
		Nannari Sharabath		Mango Pickle
		Papad		Papaya Fruit
		Dondakaya Chutney, Ghee + Podi		Milk
		Ice Cream Bar or Cup Ice Cream		Coffee Powder






Mon 6,20	Chole Bhature 3 Pcs Medium Size	Cucumber Salad	Dry Maggi ,Sauce	Carrot Salad & Onions
	Veg Pongal	Chapathi	Cold Badam Milk	Phulka
	Coconut Chutney	Pulihora		White Rice
	Brown Bread + Butter + Jam	White Rice		Paneer Bhurji  /  Chicken Fry curry
	Tea, Coffee Powder, Milk	Dondakaya Fry		Sambar
	Boiled Egg	Aloo Bhindi Masala		Tomato Rasam
	Sprouts (1 cup)	Andhra Style Muddha Pappu + Avakaya		Thick Curd
		Andhra Style Pachi Pulusu		 Lemon Pickle
		Butter Milk		Banana
		Papad		Milk
		Dosakaya Chutney, Ghee + Podi		Coffee Powder
		Rasagulla




Tue          7,21	Ghee Karam Dosa	Beetroot Salad	Punugulu 10 pcs	Cucumber Salad
	Veg Kichidi	Roti	Groundnut chutney	Chapathi
	Groundnut Chutney, Sambar	Bisbeli Bath	Ginger Tea, Coffee	White Rice
	Milk bread + Butter + Jam	White Rice		Veg biriyani (7.10.2025)/Mushroom biryani (21.10.2025), Raitha
	Tea, Coffee Powder, Milk	Jeera Aloo Fry		Mix Veg Curry
	Egg Burji	Rajma Masala		Sambar
	Sprouts (1 cup)	Lasooni Dal Tadka		Rasam
		Dahi Vada		Thick curd
		Lemonade with Sabja Seeds		 Tomato Pickle
		Potato Chips		Banana
		Dondakaya Chutney, Ghee + Podi		Milk
				Coffee Powder





Wed         8,22	Idli	Onions & Carrot Salad	Kathi Roll, Sauce	Beetroot Salad
	Vada (3 pcs Medium Size)	Phulka	   Tea, Coffee	Chapathi
	Coconut Chutney	Bhagara rice		White Rice
	Brown bread + Butter + Jam	White Rice		Veg Pasta,Tomato Sauce
	Tea, Coffee Powder, Milk	Mughlai Chicken / Kaju Paneer		Lauki Channa Masala
	Scrambled Egg 	Nizami veg		Sambar
	Sprouts (1 cup)	Dosakaya Pappu		Tomato Dal
		Rasam		Mango Pickle
		Butter Milk		Thick Curd
		Vankaya (Brinjal) Chutney, Ghee + Podi		Papaya
		Bread Halwa		Milk
				Coffee Powder





Thu          9,23	Poori 3 Pcs Std Size	Carrot Salad	Masala Vada	Cucumber Salad
	Poha	Chapathi	Ginger Tea, Coffee	 Phulka
	Besan Mix Veg Chutney	Mix Veg Pulav		White Rice
	Milk bread + Butter + Jam	White Rice		Carrot Idli, Groundnut Chutney
	Tea, Coffee Powder, Milk	Beetroot Chenna Poriyal		Bhindi Do Pyaja (Dry)
	Boiled Egg	Black chenna masala		Moong Dal Tadka
	Sprouts (1 cup)	Chukka Kura Pappu		Rasam
		Lemonade with Sabja Seeds		Sambar
		Papad		Thick Curd
		Beerakaya Chutney, Ghee + Podi		 Red chilli Pickle
				Fruit Custard(Minimum 4 types of fruits)
				Milk
				Coffee Powder




Fri          10,24	Mysore Bonda	Beetroot Salad	Masala Boiled Peanuts	Carrot Salad & Onions
	Wheat upma	Roti	 Tea, Coffee	 Roti
	Coconut chutney	Tomato Rice		White Rice
	Brown Bread + Butter + Jam	White Rice		Butter chicken / Panner Pepper Masala
	Tea, Coffee Powder, Milk	Carrot Fry		Pesara Pappu
	Masala Omlette	Kadai veg		Rasam
	Sprouts (1 cup)	Mango Dal		Thick curd
		 Rasam		 Mango Pickle
		Lassi		Fruit Custard (Minimum 4 Types Fruits)
		Dosakaya Chutney, Ghee + Podi		Milk
		Ravva Vadiyalu		Coffee Powder
		Shahi ka Tukda





Sat         11,25	Plain Dosa (3 pcs thin)	Boiled Chana with Onion & Tomato	Onion Pakoda	Cucumber Salad
	Pav Bhaji	 Chapathi	Groundnut Chutney	Chapathi
	Ground Chutney, Sambar	Tamarind Rice	Ginger Tea, Coffee	White Rice
	Milk bread + Butter + Jam	White Rice		Jeera Rice
	Tea, Coffee Powder, Milk	  Drumstick curry		Mixed Veg Curry
	Egg Burji	Sambar		Dal Tadka, Rasam
	Sprouts (1 cup)	Palak Dal		Thick curd
		Butter Milk		 Tomato Pickle
		Gongura Chutney, Ghee + Podi		Pine Apple Fruit 
		Fryums		Milk
				Coffee Powder



Sun        12,26	Gobi Paratha (2 Pcs Standard Size) 	Onions & Cucumber Salad	Pani Poori,Onions	Carrot Salad
	Shavige Bath	Chapathi	Masala Tea, Coffee	Phulka
	Groundnut Chutney, Mango Pickle, Thick Curd	Chicken Dum Biryani (NV) / Paneer Dum Vegetable Biryani (VEG)		White Rice
	Brown Bread + Butter + Jam	White Rice		Set Dosa, Groundnut Chutney
	Coffee Powder,Milk	 Gravy (Chicken GRAVY (NV)/ Hyderabadi Mirchi Ka Salan (VEG), Onion Raitha		Masoor Dal Tadka
	Boiled Egg	Punjabi Dal Fry		Sambar
	Sprouts (1 cup)	Rasam		Thick Curd 
		Nannari Sharabath		 Lemon Pickle
		Papad		Papaya Fruit
		Fresh Coriander Tomato Chutney, Ghee + Podi		Milk
		Ice Cream Bar or Cup Ice Cream		Coffee Powder

''';

  List<MessDayMenu> _parseMessMenu(String rawData) {
    List<MessDayMenu> parsedMenu = [];
    List<String> lines = rawData.split('\n');

    int startIndex = -1;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].trim().startsWith('Dates\tBreakfast\tLunch\tSnacks\tDinner')) {
        startIndex = i + 1;
        break;
      }
    }

    if (startIndex == -1) {
      return []; // Header not found
    }

    List<String> currentDayLines = [];
    for (int i = startIndex; i < lines.length; i++) {
      String line = lines[i].trim();
      if (line.isEmpty) continue;

      // Check if it's the start of a new day's entry
      if (line.startsWith('Mon') ||
          line.startsWith('Tue') ||
          line.startsWith('Wed') ||
          line.startsWith('Thu') ||
          line.startsWith('Fri') ||
          line.startsWith('Sat') ||
          line.startsWith('Sun')) {
        if (currentDayLines.isNotEmpty) {
          parsedMenu.add(_processDayEntry(currentDayLines));
          currentDayLines = [];
        }
      }
      currentDayLines.add(line);
    }
    if (currentDayLines.isNotEmpty) {
      parsedMenu.add(_processDayEntry(currentDayLines));
    }

    return parsedMenu;
  }

  MessDayMenu _processDayEntry(List<String> dayLines) {
    String dayAndDates = '';
    List<String> breakfast = [];
    List<String> lunch = [];
    List<String> snacks = [];
    List<String> dinner = [];

    for (int i = 0; i < dayLines.length; i++) {
      List<String> parts = dayLines[i].split('\t');

      if (i == 0) {
        dayAndDates = parts[0];
        breakfast.add(parts.length > 1 ? parts[1] : '');
        lunch.add(parts.length > 2 ? parts[2] : '');
        snacks.add(parts.length > 3 ? parts[3] : '');
        dinner.add(parts.length > 4 ? parts[4] : '');
      } else {
        // Subsequent lines for the same day might not have a date part
        breakfast.add(parts.length > 1 ? parts[1] : '');
        lunch.add(parts.length > 2 ? parts[2] : '');
        snacks.add(parts.length > 3 ? parts[3] : '');
        dinner.add(parts.length > 4 ? parts[4] : '');
      }
    }

    return MessDayMenu(
      dayAndDates: dayAndDates.trim(),
      breakfast: breakfast.where((e) => e.isNotEmpty).map((e) => e.trim()).toList(),
      lunch: lunch.where((e) => e.isNotEmpty).map((e) => e.trim()).toList(),
      snacks: snacks.where((e) => e.isNotEmpty).map((e) => e.trim()).toList(),
      dinner: dinner.where((e) => e.isNotEmpty).map((e) => e.trim()).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<MessDayMenu> messMenu = _parseMessMenu(_messMenuRawData);

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Mess Menu', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white), // For back button color
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal padding
        child: ListView.builder(
          itemCount: messMenu.length,
          itemBuilder: (context, index) {
            MessDayMenu dayMenu = messMenu[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.blueGrey[700],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayMenu.dayAndDates,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const Divider(color: Colors.white70),
                    _buildMealSection('Breakfast', dayMenu.breakfast),
                    _buildMealSection('Lunch', dayMenu.lunch),
                    _buildMealSection('Snacks', dayMenu.snacks),
                    _buildMealSection('Dinner', dayMenu.dinner),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMealSection(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          ...
              items.map((item) => Text('- $item', style: const TextStyle(color: Colors.white54), softWrap: true)).toList(),
        ],
      ),
    );
  }
}
