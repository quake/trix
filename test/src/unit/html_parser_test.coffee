module "Trix.HTMLParser"

eachFixture (name, {html, document}) ->
  test name, ->
    {attachments} = document
    expectHTML Trix.HTMLParser.parse(html, {attachments}).getDocument(), html

asyncTest "sanitizes unsafe html", ->
  window.unsanitized = []
  Trix.HTMLParser.parse """
    <img onload="window.unsanitized.push('img.onload');" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACwAAAAAAQABAAACAkQBADs=">
    <img onerror="window.unsanitized.push('img.onerror');" src="data:image/gif;base64,TOTALLYBOGUS">
    <script>
      window.unsanitized.push('script tag');
    </script>
  """
  after 20, ->
    deepEqual window.unsanitized, []
    delete window.unsanitized
    QUnit.start()
