# coworkers

A new Flutter project.

## Getting Started
Para dar deploy no projeto: (Lembrar de editar a descrição do commit)


TODO: Lembrar de adicionar uma tag para a versão. junto com o commit de Lançamento da versão x.y.z
```
dart run build_runner build --delete-conflicting-outputs && flutter test && git add . && git commit -am "feat anti-duplication" && git push && flutter build web && firebase deploy --only hosting
```