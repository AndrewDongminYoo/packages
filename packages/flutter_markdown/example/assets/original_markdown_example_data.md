# Markdown Example

Markdown allows you to easily include formatted text, images, and even formatted Dart code in your app.

## Titles

Setext-style

```
This is an H1
=============

This is an H2
-------------
```

Atx-style

```
# This is an H1

## This is an H2

###### This is an H6
```

Select the valid headers:

- [x] `# hello`
- [ ] `#hello`

## Links

[Google's Homepage][Google]

```
[inline-style](https://www.google.com)

[reference-style][Google]
```

## Images

![Flutter logo](/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png)

## Tables

| Syntax                                  | Result                                |
| --------------------------------------- | ------------------------------------- |
| `*italic 1*`                            | _italic 1_                            |
| `_italic 2_`                            | _italic 2_                            |
| `**bold 1**`                            | **bold 1**                            |
| `__bold 2__`                            | **bold 2**                            |
| `This is a ~~strikethrough~~`           | This is a ~~strikethrough~~           |
| `***italic bold 1***`                   | **_italic bold 1_**                   |
| `___italic bold 2___`                   | **_italic bold 2_**                   |
| `***~~italic bold strikethrough 1~~***` | **_~~italic bold strikethrough 1~~_** |
| `~~***italic bold strikethrough 2***~~` | ~~**_italic bold strikethrough 2_**~~ |

## Styling

Style text as _italic_, **bold**, ~~strikethrough~~, or `inline code`.

- Use bulleted lists
- To better clarify
- Your points

## Code blocks

Formatted Dart code looks really pretty too:

```
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Markdown(data: markdownData),
    ),
  ));
}
```

## Center Title

###### ※ ※ ※

_\* How to implement it see main.dart#L129 in example._

## Custom Syntax

NaOH + Al_2O_3 = NaAlO_2 + H_2O

C_4H_10 = C_2H_6 + C_2H_4

## Markdown widget

This is an example of how to create your own Markdown widget:

    Markdown(data: 'Hello _world_!');

Enjoy!

[Google]: https://www.google.com/

## Line Breaks

This is an example of how to create line breaks (tab or two whitespaces):

line 1

line 2

line 3
