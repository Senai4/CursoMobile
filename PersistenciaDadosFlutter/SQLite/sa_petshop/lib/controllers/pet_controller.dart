import 'package:sa_petshop/models/pet_model.dart';
import 'package:sa_petshop/services/db_helper.dart';

class PetController {

  final _dbHelper = DbHelper();

  // métodos do controller

  Future<int> createPet(Pet pet) async{
    return _dbHelper.insertPet(pet);
  }

  Future<List<Pet>> readPet() async{
    return _dbHelper.getPets();
  }

  Future<Pet?> readPetById(int id) async{
    return _dbHelper.getPetById(id);
  }

  Future<int> deletePet(int id) async{
    return _dbHelper.deletePet(id);
  }

}