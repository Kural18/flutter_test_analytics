import 'dart:convert';

class Cartoon {
  final String character_image_url;
  final String name;
  final String description;
  final List<String> characterTraits;
  final List<String> superpowers;

  Cartoon(this.character_image_url, this.name, this.description, this.characterTraits, this.superpowers);

  factory Cartoon.fromJson(Map<String, dynamic> json) {
    final String characterDescriptionString = json['character_description'];
    final String imageUrl;

    final Map<String, dynamic> characterDescriptionMap = jsonDecode(characterDescriptionString);
      List<String> _handleSuperpowers(dynamic superpowers) {
        if (superpowers is List) {
          return superpowers.cast<String>();
        } else {
          return [superpowers as String]; // Convert single string to a list with one element
        }
      }

    if (json['character_image_url'] is String) {
      imageUrl = json['character_image_url'] as String;
    } else if (json['character_image_url'] is List) {
      final imageUrls = json['character_image_url'] as List;
      if (imageUrls.isNotEmpty) {
        imageUrl = imageUrls.first;
      } else {
        // Handle the case where the list is empty (optional)
        print("Error: character_image_url list is empty");
        imageUrl = ""; // Set a default value or handle it elsewhere
      }
    } else {
      // Handle unexpected data type (optional)
      print("Error: character_image_url has unexpected data type");
      imageUrl = ""; // Set a default value or handle it elsewhere
    }

    return Cartoon(
      imageUrl,//json['character_image_url'],
      characterDescriptionMap['Name'] as String,
      characterDescriptionMap['Description'] as String,
      _handleSuperpowers(characterDescriptionMap['Character Traits']) as List<String>, // Handle character traits
      _handleSuperpowers(characterDescriptionMap['Superpowers']) as List<String>,
    );
  }

}


class Adventure {
  final Map<String, dynamic> textAdventureOutput;
  final List<String> imageUrls;

  Adventure(this.textAdventureOutput, this.imageUrls);

  factory Adventure.fromJson(Map<String, dynamic> json) {
    print("Entered the fromJSon function inside Adventure");
    final textAdventureOutput = json['text_adventure'] as Map<String, dynamic>;
    print("Let's print out the various parts");
    print("introduction is ");
    print(textAdventureOutput['introduction']);
    print("challenges are ");
    print(textAdventureOutput['challenges']);
    print("conclusion is ");
    print(textAdventureOutput['conclusion']);

    return Adventure(
      {
        'introduction': textAdventureOutput['introduction'] as String,
        'challenges': (textAdventureOutput['challenges'] as List).cast<String>(),
        'conclusion': textAdventureOutput['conclusion'] as String,
      },
      (json['imageURLList'] as List).cast<String>(),
    );
  }
}
