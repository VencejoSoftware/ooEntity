[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

# ooEntiy - Object pascal entity library
Attempt to implement the [domain model](https://en.wikipedia.org/wiki/Domain_model) concept in OO, with interfaces to marshall/unmarshall data in entity objects

### Example of TextKey definition
```pascal
var
  Key: ITextKey;
begin
  // If the value is empty a error is raised
  Key := TTextKey.New('ID');
end;
```

### Documentation
If not exists folder "code-documentation" then run the batch "build_doc". The main entry is ./doc/index.html

### Demo
See tests code for examples of use.

## Built With
* [Delphi&reg;](https://www.embarcadero.com/products/rad-studio) - Embarcadero&trade; commercial IDE
* [Lazarus](https://www.lazarus-ide.org/) - The Lazarus project

## Contribute
This are an open-source project, and they need your help to go on growing and improving.
You can even fork the project on GitHub, maintain your own version and send us pull requests periodically to merge your work.

## Authors
* **Alejandro Polti** (Vencejo Software team lead) - *Initial work*