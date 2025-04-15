import 'package:hive/hive.dart';
import 'package:mypost/data/entity/quote_entity/quote_entity.dart';
import 'package:mypost/data/entity/user_entity/user_entity.dart';

late Box quotesBox;
late Box userBox;
List<QuoteEntity> quotesDataList = [];
UserEntity? userProfileData;
bool adEnable = false;
