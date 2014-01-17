HEAR THE CITY
-------------

Written for the EU arts council's ICT ART Connect project.

setup:

* sudo apt-get install lilypond
* bundle install
* mysql -u root -p
* create database hear_the_city;
* `cp config.yml.template config.yml`

Command line operation: 

To watch existing messages:
`ruby scripts/monitor.rb`
`rackup config.ru`

To download instagram images for use elsewhere:
`ruby scripts/instagram_location_search.rb`

To gather tweets per location:
`ruby scripts/twitter.rb`

Types of data
-------------

Because hear the city is an attempt to produce an artistic installation with data which is from HERE and NOW, data will be coming from a variety of internet sources. This is a list of data sources and a breif description of what they are and what the data looks like.

Currently implemented (data gathering):

Data gethering implimentation must mean the data is gathered and stored in the hear the city database, so it can be easily retrieved for installation use.

<table>
  <tr>
    <th>Name</th>
    <th>Website</th>
    <th>Description</th>
    <th>Attributes</th>
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

Currently implimented (gathering and installation)

(none)

Possible:

<table>
  <tr>
    <th>Name</th>
    <th>Possible Website(s)</th>
    <th>Description</th>
    <th>Possible<br/>Attributes</th>
  </tr>
  <tr>
    <td>Twitter</td>
    <td>www.twitter.com</td>
    <td>Short (up to 140 character) messages - things being said about that place</td>
    <td>
      tweet<br/>
      user<br/>
      lat<br/>
      long<br/>
    </td>
  </tr>
  <tr>
    <td>Weather</td>
    <td>http://api.openweathermap.org/data/2.5/weather?q=London,uk</td>
    <td>Weather data for the current time and place</td>
    <td>
      sunrise<br/>
      sunset<br/>
      weather summary (e.g. rain)<br/>
      temperature (also min and max)<br/>
      pressure<br/>
      humidity<br/>
      wind speed and direction<br/>
      amount of rain
    </td>
  </tr>
  <tr>
    <td>Smart Cities Guide</td>
    <td>http://mashweb.fokus.fraunhofer.de:3008/api/cities?name=Nantes</td>
    <td>General city and point of interest information, seems limited. (does not include Brussels or London, or anywhere in England or Belgium)</td>
    <td>
      <h4>City</h4>
      long<br/>
      lat<br/>
      description<br/>
      name<br/>
      image (url)<br/>
      <h4>POI</h4>
      name<br/>
      description<br/>
      image<br/>
      long<br/>
      lat
    </td>
  </tr>  
  <tr>
    <td>Noisetube</td>
    <td>http://noisetube.net/api_overview</td>
    <td>Noise level measurements in a given city - not sure about this, it looks good for finding past levels and change over time. Less so for here and now. Mostly this would be one figure. "how loud is here?"</td>
    <td>
      (noise measurements)<br/>
      lat<br/>
      long<br/>
      tags<br/>
      l (would appear to be actual noise level, possibly decibels)
    </td>
  </tr>
  <tr>
    <td>BBC News</td>
    <td>news.bbc.co.uk</td>
    <td>News RSS feeds, this get's fairly localised within the UK (counties and large cities), not so for Brussels.</td>
    <td>
      Healine<br/>
      sub-header (short paragraph)<br/>
      main body<br/>
      time posted
    </td>
    
  </tr>

</table>


