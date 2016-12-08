Themes / Styles
======================================================

The report modules allows you to use different themes for rendering html.


Use different Theme
-----------------------------------------------------
You may select the theme to use in the option's `style` settings:

``` coffee
report.toHtml
  style: 'my-theme'
, (err, html) ->
```

If you don't select one you will get the included `default` theme.


Location of Theme
--------------------------------------------------------
The template and style files have to be named:

    <theme>.hbs - handlebars template for outer page structure
    <theme>.css - stylesheet for display

These files have to be available in any of the following paths:

General search path:

>  `/etc/alinex/template`\
>  `~/.alinex/template`

Within the report package installation path:

> `var/src/template` - defaults in the source code\
> `var/local/template` - local within the installed program

In the report configuration:

> `/etc/report/template` - global for the application\
> `~/.report/template` - user specific settings

Or within your own setup directories if you have them registered for `template`
type using {@link alinex-config}.

So if you have your own theme put the files in one of the above directories. The
later ones have precedence.


Writing Theme
---------------------------------------------------------
If you want to create your own theme you have to create the two template files.

### Handlebars Template

This should have the name `<theme>.hbs` and may look like:

``` handlebars
<!DOCTYPE html>
<html lang="{{locale}}">
  <head>
    <title>{{title}}</title>
    <meta charset="UTF-8" />
    {{{join header ""}}}
  </head>
  <body><div id="page">{{{content}}}</div></body>
</html>
```

As shown you may use the four variables:
- `locale` - for the locale of the page
- `title` - for the page title (first heading of report)
- `header` - html header containing javascript and style links and code
- `content` - the real report body

### Stylesheet

The default stylesheets are created on build time out of an
[Stylus](http://stylus-lang.com/docs/js.html) file using also [Axis](http://axis.netlify.com/)
and [nib](https://tj.github.io/nib/). But you don't have to use it, you may use any
language like LESS, Sass or raw CSS. In all cases you have to compile it to CSS
under `<theme>.css` before adding it.

With styles a lot is possible. A good way may also be designing it on the fly in
the developer tools of your browser on an example output file with empty css file
to start with.
