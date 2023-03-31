// 모든 model에 id가 무조건 있다고 정의
abstract class IModelWithId{
  final String id;

  IModelWithId({
    required this.id,
  });
}