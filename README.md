# ocw-course-hugo-starter

A starter template for a Hugo site that uses [`ocw-course-hugo-theme`](https://github.com/mitodl/ocw-course-hugo-theme)

![image](https://user-images.githubusercontent.com/12089658/102410491-9b7e1680-3fbe-11eb-9746-e5ae996add40.png)

## Prerequisites

 - NodeJS
 - Hugo

## Building JS & CSS

To build the JS and CSS for the theme, make sure you have the above prerequisites installed and run the following:

```sh
./build.sh
```

## Running the site

To preview your site, run the following command:

```sh
hugo server
```

Hugo will watch your site source and refresh the page as you make changes to the site content.

## Adding content

Course level metadata for your course should be placed in the JSON format under the `data/courses` folder with a filename matching the course's ID.  For example: `data/courses/18-01-single-variable-calculus-fall-2006.json`.

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

The `type` and `layout` values in front matter tell Hugo which page to render, and the `menu` object creates a nav entry for the page.  Detailed info on course-level metadata and layouts can be found in the [`ocw-course-hugo-theme`](https://github.com/mitodl/ocw-course-hugo-theme) readme.
