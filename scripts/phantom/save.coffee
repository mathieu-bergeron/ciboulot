# vim: set fileencoding=utf-8 :
#
# Ciboulot: a simple Web App for text-based content and Angular.js delivery
# Copyright (C) 2014 Mathieu Bergeron

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


webpage = require 'webpage'
fs = require 'fs'
system = require 'system'

if system.args.length < 3
    console.log 'usage: phantomjs ' + system.args[0] + ' TARGET_URL TARGET_FILE IMAGE_DIR'
    phantom.exit()

target_url = system.args[1]
target_file = system.args[2]

# XXX: asuming 'images'
# FIXME: the image_dir var is not accessible in page.evaluate
image_dir = system.args[3]


JQUERY = "http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"


save_image = (image_id, data) ->
    image_url = image_dir + '/' + image_id + '.base64'
    console.log 'saving ' + image_url
    data = data.replace /data[^,]+,/, ''
    fs.write image_url, data, 'w'

    # Buffer not supported.
    # nodejs version issue?
    # data_bin = new (Buffer str, 'base64').toString 'binary'



page = webpage.create()
process_page = () ->

    # Use jQuery
    page.includeJs JQUERY, () ->
        # Replace <canvas> tags by <img> tags
        # return the canvas img data
        images_dict = page.evaluate () ->
            images_dict = {}
            for_each_canvas = (i, canvas) ->
                # Save canvas png
                if not (canvas.id of images_dict)

                    # XXX: trying to remove image smoothing when saving data
                    # ctx = canvas.getContext '2d'
                    # ctx.imageSmoothingEnabled = false

                    images_dict[canvas.id] = canvas.toDataURL 'png'

                # Replace the canvas by a img tag
                $(canvas).replaceWith "<img src='" + "images/" + canvas.id + ".png"  + "'></img>"


            $('canvas').each for_each_canvas

            images_dict

        for image_id, data of images_dict
            save_image image_id, data

        # get html of whole document
        main_html = page.evaluate () ->
            $('body').html()

        main_html = "<body>#{main_html}</body>"

        # remove inclusion of jquery
        jquery_inclusion = "<script src=\"#{JQUERY}\"></script>"
        jquery_inclusion = new RegExp jquery_inclusion, 'g'
        main_html = main_html.replace jquery_inclusion, ''

        header = """<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>ciboulot</title>
  <link rel="stylesheet" href="../css/ciboulot.css"/>
</head>"""

        fs.write target_file, header + main_html, 'w'

        phantom.exit()


page.open target_url, () ->
    # timeout necessary?
    #window.setTimeout process_page, 200
    window.setTimeout process_page, 0
