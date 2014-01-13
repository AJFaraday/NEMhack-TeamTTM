HEAR THE CITY
-------------

Written for the EU arts council's ICT ART Connect project.

setup:

* bundle install
* mysql -u root -p
* create database hear_the_city;

Command line operation: 

To watch existing messages:
`ruby scripts/monitor.rb`

To download instagram images for use elsewhere:
`ruby scripts/instagram_location_search.rb`

Types of data
-------------

Because hear the city is an attempt to produce an artistic installation with data which is from HERE and NOW, data will be coming from a variety of internet sources. This is a list of data sources and a breif description of what they are and what the data looks like.

Currently implemented (data gathering):

<table>
  <tr>
    <th>Name</th>
    <th>Website</th>
    <th>Description<th>
    <th>attributes</th>
  </tr>
  <tr>
    <td>Instagram</td>
    <td>www.instagram.com</td>
    <td>Highly compressed square-aspect images</td>
    <td>
      label (caption and user)<br/>
      lat (latitude)<br/>
      long (longitude)<br/>
      url<br/>
      filename<br/>
    </td>
  </tr>
</table>
