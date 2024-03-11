# Dart Mappable Fork
This project is a fork of the [dart_mappable](https://pub.dev/packages/dart_mappable) package, with a key difference in the behavior of the `copyWith` method.

## Difference

#### Null Assignment Handling:
This fork overrides the default `copyWith` behavior to ignore null assignments. This means that attempting to assign a null value to a property using `copyWith` will not alter the original value.

#### Example:
```dart
final person = Person(name: 'Tom', age: 20);

// assign age to null
print(person.copyWith(age: null));
```

The original behavior would result in:
```dart
Person(name: Tom, age: null)
```

But with the modification, age remains unchanged:
```dart
Person(name: Tom, age: 20)
```

## Code Modification
The change is made within the `FieldCopyWithData` class:

### Original

```dart
class FieldCopyWithData extends CopyWithData {
  FieldCopyWithData(this.fields);

  final Map<Symbol, dynamic> fields;

  @override
  V get<V>(Symbol name, {Object? or = $none}) {
    if (fields.containsKey(name) || or == $none) {
      return fields[name] as V;
    } else {
      return or as V;
    }
  }
}
```

### Modified

```dart
class FieldCopyWithData extends CopyWithData {
  FieldCopyWithData(this.fields);

  final Map<Symbol, dynamic> fields;

  @override
  V get<V>(Symbol name, {Object? or = $none}) {
    var v = fields[name];
    if ((fields.containsKey(name) && v != null) || or == $none) {
      return v as V;
    } else {
      return or as V;
    }
  }
}
```
