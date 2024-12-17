import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_diamond_users/src/controllers/category/category_event.dart';
import 'package:hot_diamond_users/src/controllers/category/category_state.dart';
import 'package:hot_diamond_users/src/model/category/category_model.dart';



class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<FetchCategoriesEvent>(_fetchCategoryies);
    on<SelectCategoryEvent>(_selectedCategory);
    on<ShowAllItemsEvent>(_showAllItems);
  }


  Future _fetchCategoryies(CategoryEvent event, Emitter emit)async{
    emit(CategoryLoading());
    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('categories').get();
      List<CategoryModel> categories = snapshot.docs.map((doc)=> CategoryModel.fromFireStore(doc)).toList();
      emit(CategoryLoaded(categories: categories,selectedCategoryId: 'all'));
    }catch(e){
      emit(CategoryError(message: e.toString()));
    }
  }

  _selectedCategory(SelectCategoryEvent event, Emitter emit) {
    if (state is CategoryLoaded) {
      final loadedState = state as CategoryLoaded;
      emit(CategoryLoaded(
        categories: loadedState.categories,
        selectedCategoryId: event.categoryId,
      ));
    }
  }

    // Event handler for showing all items
  Future _showAllItems(ShowAllItemsEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      // Emit the same state with null selectedCategoryId to fetch all items
      emit(CategoryLoaded(categories: [], selectedCategoryId: 'all'));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }
}
