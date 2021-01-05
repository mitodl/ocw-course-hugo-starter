# ocw-course-hugo-starter

A starter template for a Hugo site that uses [`ocw-course-hugo-theme`](https://github.com/mitodl/ocw-course-hugo-theme)

![image](https://user-images.githubusercontent.com/12089658/102410491-9b7e1680-3fbe-11eb-9746-e5ae996add40.png)

## Prerequisites

 - [NodeJS](https://nodejs.org/en/download/)
 - [Yarn](https://classic.yarnpkg.com/en/docs/install)
 - [Hugo](https://gohugo.io/getting-started/installing)

## Building JS & CSS

To build the JS and CSS for the theme, make sure you have the above prerequisites installed and run the following:

```sh
./build.sh
```

By default, artifacts are output to the `static` folder.  

## Building multiple courses for use with a larger site

Optionally, using the same `build.sh` script as above, you may specify an external directory or pull in content output by [ocw-to-hugo](https://github.com/mitodl/ocw-to-hugo).

| Option | Description |
| --- | --- |
| `-o, --output` | This is an optional path to output build artifacts to. |
| `-c, --courses` | This is a path to the output of a run of `ocw-to-hugo`.  When this is specified, webpack artifacts will be built first and output to the path specified with `-o`.  Afterward, courses in the `ocw-to-hugo` output will be iterated and built using `hugo`, outputting to the path specified with `-o`. |
| `-b, --baseUrl` | A `baseUrl` property to be prepended to each course ID when running with the `-c` argument above |

These options are meant for using this course site in the context of a larger static website.  The idea is that you specify the path to your built static site with `-o`, then a path to course data (currently provided by [ocw-to-hugo](https://github.com/mitodl/ocw-to-hugo)) with `-c`.  Webpack artifacts are built and deposited in the specified output, followed by all of the courses passed in which are rendered to the `courses` folder in the same output folder.

## Running the site

To preview your site, run the following command:

```sh
hugo server
```

You should see output like this: 

```sh
Start building sites … 
WARN 2020/12/17 09:33:52 Page.URL is deprecated and will be removed in a future release. Use .Permalink or .RelPermalink. If what you want is the front matter URL value, use .Params.url

                   | EN   
-------------------+------
  Pages            | 161  
  Paginator pages  |   0  
  Non-page files   |   0  
  Static files     | 460  
  Processed images |   0  
  Aliases          |   0  
  Sitemaps         |   1  
  Cleaned          |   0  

Built in 267 ms
Watching for changes in /home/c4103/Code/ocw-course-hugo-starter/{_vendor,archetypes,content,data,package.json,static}
Watching for config changes in /home/c4103/Code/ocw-course-hugo-starter/config.toml, /home/c4103/Code/ocw-course-hugo-starter/go.mod
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
Press Ctrl+C to stop
```

The site will be hosted at the URL mentioned at the end, and options such as the port number can be set with arguments described [here](https://gohugo.io/commands/hugo_server/).  Hugo will watch your site source and refresh the page as you make changes to the site content.

## Adding content

Course level metadata for your course should be placed in the JSON format under the `data/courses` folder with a filename matching the course's ID.  For example: `data/courses/18-01-single-variable-calculus-fall-2006.json`.  Detailed info on course-level metadata can be found in the [`ocw-course-hugo-theme`](https://github.com/mitodl/ocw-course-hugo-theme#course-data-template) readme.

### Course home page

Your course's home page can be created by creating an `_index.md` file in the `content` folder.  Here is an example for `18-01-single-variable-calculus-fall-2006`:

```md
---
title: Course Home
type: course
layout: course_home
course_id: 18-01-single-variable-calculus-fall-2006
menu:
  18-01-single-variable-calculus-fall-2006:
    identifier: course-home
    weight: -10
---
This introductory calculus course covers differentiation and integration of functions of one variable, with applications.

```

### Course sections

Course sections should be placed in `content/sections`.  Here is an example of the beginning of the file representing the Syllabus section of `18-01-single-variable-calculus-fall-2006`:

```md
---
title: Syllabus
course_id: 18-01-single-variable-calculus-fall-2006
type: course
layout: course_section
menu:
  18-01-single-variable-calculus-fall-2006:
    identifier: 65cb45fb6cb01e83dce485f41e5471b5
    weight: 10

---
## Course Meeting Times

Lectures: 3 sessions / week, 1 hour / session

Recitation: 2 sessions / week, 1 hour / session\[  
\]({{% getpage "sections/video-lectures-creole/_index.md" %}})
...
```

The `type` and `layout` values in front matter tell Hugo which page to render, and the `menu` object creates a nav entry for the page.  Detailed info on layouts can be found in the [`ocw-course-hugo-theme`](https://github.com/mitodl/ocw-course-hugo-theme#layouts) readme.
