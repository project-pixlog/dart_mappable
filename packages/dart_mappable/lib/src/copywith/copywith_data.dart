import '../../dart_mappable.dart';

abstract class CopyWithData {
  V get<V>(Symbol name, {Object? or});
}

class FieldCopyWithData extends CopyWithData {
  FieldCopyWithData(this.fields);

  final Map<Symbol, dynamic> fields;

  @override
  V get<V>(Symbol name, {Object? or = $none}) {
    // This modification makes FieldCopyWithData behave as MergeCopyWithData
    final v = fields[name];
    if ((fields.containsKey(name) && v != null) || or == $none) {
      return v as V;
    } else {
      return or as V;
    }
  }
}

class MergeCopyWithData extends CopyWithData {
  MergeCopyWithData(this.mapper, this.value);

  final ClassMapperBase mapper;
  final Object value;

  @override
  V get<V>(Symbol name, {Object? or = $none}) {
    var v = mapper.fields[name]!.get(value);
    if (v != null || or == $none) {
      return v as V;
    } else {
      return or as V;
    }
  }
}

class DeltaCopyWithData extends CopyWithData {
  DeltaCopyWithData(this.mapper, this.value)
      : context = DecodingContext(container: MapperContainer.globals);

  final ClassMapperBase mapper;
  final Map<String, dynamic> value;
  final DecodingContext context;

  @override
  V get<V>(Symbol name, {Object? or = $none}) {
    if (value.containsKey(mapper.fields[name]!.key) || or == $none) {
      return mapper.fields[name]!.decode(value, context);
    } else {
      return or as V;
    }
  }
}
