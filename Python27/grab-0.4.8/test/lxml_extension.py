# coding: utf-8
from unittest import TestCase
from grab import Grab, DataNotFound

from test.util import (GRAB_TRANSPORT, RESPONSE, BASE_URL,
                       FakeServerThread)

HTML = u"""
<head>
    <title>фыва</title>
    <meta http-equiv="Content-Type" content="text/html; charset=cp1251" />
</head>
<body>
    <div id="bee">
        <div class="wrapper">
            <strong id="bee-strong">пче</strong><em id="bee-em">ла</em>
        </div>
        <script type="text/javascript">
        mozilla = 777;
        </script>
        <style type="text/css">
        body { color: green; }
        </style>
    </div>
    <div id="fly">
        <strong id="fly-strong">му\n</strong><em id="fly-em">ха</em>
    </div>
    <ul id="num">
        <li id="num-1">item #100 2</li>
        <li id="num-2">item #2</li>
    </ul>
""".encode('cp1251')


XML = """
<root>
    <man>
        <age>25</age>
        <weight><![CDATA[30]]></weight>
    </man>
</root>
"""


class LXMLExtensionTest(TestCase):
    def setUp(self):
        # Create fake grab instance with fake response
        self.g = Grab(transport=GRAB_TRANSPORT)
        self.g.fake_response(HTML, charset='cp1251')
        FakeServerThread().start()

        from lxml.html import fromstring
        self.lxml_tree = fromstring(self.g.response.body)

    def test_lxml_text_content_fail(self):
        # lxml node text_content() method do not put spaces between text
        # content of adjacent XML nodes
        self.assertEqual(self.lxml_tree.xpath('//div[@id="bee"]/div')[0].text_content().strip(), u'пчела')
        self.assertEqual(self.lxml_tree.xpath('//div[@id="fly"]')[0].text_content().strip(), u'му\nха')

    def test_lxml_xpath(self):
        names = set(x.tag for x in self.lxml_tree.xpath('//div[@id="bee"]//*'))
        self.assertEqual(set(['em', 'div', 'strong', 'style', 'script']), names)
        names = set(x.tag for x in self.lxml_tree.xpath('//div[@id="bee"]//*[name() != "script" and name() != "style"]'))
        self.assertEqual(set(['em', 'div', 'strong']), names)

    def test_xpath(self):
        self.assertEqual('bee-em', self.g.xpath('//em').get('id'))
        self.assertEqual('num-2', self.g.xpath(u'//*[text() = "item #2"]').get('id'))
        self.assertRaises(DataNotFound,
            lambda: self.g.xpath('//em[@id="baz"]'))
        self.assertEqual(None, self.g.xpath('//zzz', default=None))
        self.assertEqual('foo', self.g.xpath('//zzz', default='foo'))

    def test_xpath_text(self):
        self.assertEqual(u'пче ла', self.g.xpath_text('//*[@id="bee"]', smart=True))
        self.assertEqual(u'пчела mozilla = 777; body { color: green; }', self.g.xpath_text('//*[@id="bee"]', smart=False))
        self.assertEqual(u'пче ла му ха item #100 2 item #2', self.g.xpath_text('/html/body', smart=True))
        self.assertRaises(DataNotFound,
            lambda: self.g.xpath_text('//code'))
        self.assertEqual(u'bee', self.g.xpath('//*[@id="bee"]/@id'))
        self.assertRaises(DataNotFound,
            lambda: self.g.xpath_text('//*[@id="bee2"]/@id'))

    def test_xpath_number(self):
        self.assertEqual(100, self.g.xpath_number('//li'))
        self.assertEqual(100, self.g.xpath_number('//li', make_int=True))
        self.assertEqual('100', self.g.xpath_number('//li', make_int=False))
        self.assertEqual(1002, self.g.xpath_number('//li', ignore_spaces=True))
        self.assertEqual('1002', self.g.xpath_number('//li', ignore_spaces=True,
                         make_int=False))
        self.assertRaises(DataNotFound,
            lambda: self.g.xpath_number('//liza'))
        self.assertEqual('foo', self.g.xpath_number('//zzz', default='foo'))

    def test_xpath_list(self):
        self.assertEqual(['num-1', 'num-2'],
            [x.get('id') for x in self.g.xpath_list('//li')])

    def test_css(self):
        self.assertEqual('bee-em', self.g.css('em').get('id'))
        self.assertEqual('num-2', self.g.css('#num-2').get('id'))
        self.assertRaises(DataNotFound,
            lambda: self.g.css('em#baz'))
        self.assertEqual('foo', self.g.css('zzz', default='foo'))

    def test_css_text(self):
        self.assertEqual(u'пче ла', self.g.css_text('#bee', smart=True))
        self.assertEqual(u'пче ла му ха item #100 2 item #2', self.g.css_text('html body', smart=True))
        self.assertRaises(DataNotFound,
            lambda: self.g.css_text('code'))
        self.assertEqual('foo', self.g.css_text('zzz', default='foo'))

    def test_css_number(self):
        self.assertEqual(100, self.g.css_number('li'))
        self.assertEqual('100', self.g.css_number('li', make_int=False))
        self.assertEqual(1002, self.g.css_number('li', ignore_spaces=True))
        self.assertRaises(DataNotFound,
            lambda: self.g.css_number('liza'))
        self.assertEqual('foo', self.g.css_number('zzz', default='foo'))

    def test_css_list(self):
        self.assertEqual(['num-1', 'num-2'],
            [x.get('id') for x in self.g.css_list('li')])

    def test_strip_tags(self):
        self.assertEqual('foo', self.g.strip_tags('<b>foo</b>'))
        self.assertEqual('foo bar', self.g.strip_tags('<b>foo</b> <i>bar'))
        self.assertEqual('foobar', self.g.strip_tags('<b>foo</b><i>bar'))
        self.assertEqual('foo bar', self.g.strip_tags('<b>foo</b><i>bar', smart=True))
        self.assertEqual('', self.g.strip_tags('<b> <div>'))

    def test_css_exists(self):
        self.assertTrue(self.g.css_exists('li#num-1'))
        self.assertFalse(self.g.css_exists('li#num-3'))

    def test_xpath_exists(self):
        self.assertTrue(self.g.xpath_exists('//li[@id="num-1"]'))
        self.assertFalse(self.g.xpath_exists('//li[@id="num-3"]'))

    def test_cdata_issue(self):
        g = Grab(transport=GRAB_TRANSPORT)
        g.fake_response(XML)

        # By default HTML DOM builder is used
        # It handles CDATA incorrectly
        self.assertEqual(None, g.xpath('//weight').text)
        self.assertEqual(None, g.tree.xpath('//weight')[0].text)

        # But XML DOM builder produces valid result
        #self.assertEqual(None, g.xpath('//weight').text)
        self.assertEqual('30', g.xml_tree.xpath('//weight')[0].text)

        # Use `content_type` option to change default DOM builder
        g = Grab(transport=GRAB_TRANSPORT)
        g.fake_response(XML)
        g.setup(content_type='xml')

        self.assertEqual('30', g.xpath('//weight').text)
        self.assertEqual('30', g.tree.xpath('//weight')[0].text)

    def test_xml_declaration(self):
        """
        HTML with XML declaration shuld be processed without errors.
        """
        RESPONSE['get'] = """<?xml version="1.0" encoding="UTF-8"?>
        <html><body><h1>test</h1></body></html>
        """
        g = Grab()
        g.go(BASE_URL)
        self.assertEqual('test', g.xpath_text('//h1'))

    def test_empty_document(self):
        RESPONSE['get'] = 'oops'
        g = Grab()
        g.go(BASE_URL)
        g.xpath_exists('//anytag')

        RESPONSE['get'] = '<frameset></frameset>'
        g = Grab()
        g.go(BASE_URL)
        g.xpath_exists('//anytag')
