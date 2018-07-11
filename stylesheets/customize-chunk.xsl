<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook">
				
	<xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/xhtml/chunk.xsl"/>
	
	<xsl:import href="customizedtitlepages-xhtml.xsl"/>	<!-- http://www.sagehill.net/docbookxsl/TitlePageGraphics.html -->

	<xsl:import href="customize-common.xsl"/>
	
	<xsl:param name="root.filename" select="''"/>
	<xsl:param name="use.id.as.filename" select="'1'"/>
	
	<xsl:param name="chunk.section.depth" select="4"></xsl:param>	<!-- default is 3, which makes PS3.3 sections too large. -->
	
	<!-- specify default body font and size -->
	<xsl:param name="body.font.family" select="'sans-serif'"/>
	<xsl:param name="body.font.master" select="9"/>

	<xsl:param name="draft.mode" select="'no'"/>
	<xsl:param name="draft.watermark.image" select="'http://docbook.sourceforge.net/release/xsl/current/images/draft.png'"/>	<!-- uses rewrite rule in catalog.xml to find it -->
	
	<xsl:param name="xref.with.number.and.title" select="'1'"/>
	<xsl:param name="glossentry.show.acronym" select="'yes'"/>
	<xsl:param name="index.on.role" select="'1'"/>			<!-- use old role rather than type terminology in case 4.2 or earlier DTD encountered - see note in DocBook XSL Ch 18 Indexes - Specialized Indexes -->

	<xsl:param name="olink.doctitle" select="'maybe'"/>

	<xsl:param name="xref.label-title.separator" select="' '"/>		<!-- rather than default ': '; see "http://www.sagehill.net/docbookxsl/CustomXrefs.html" -->

	<!-- footnotes in tables are numbered -->
	<xsl:param name="table.footnote.number.format" select="'1'"/>
	
	<xsl:param name="runinhead.default.title.end.punct" select="''"/>	<!-- do NOT use default period after formalpara titles -->

	<xsl:param name="make.clean.html" select="'0'"></xsl:param>		<!-- tried setting this to '1' to activate <span class="formalpara-title"/> around formalpara title without customizing xhtml/block.xsl, but messed up too many things :( -->

	<!-- section depth in TOC -->
	<xsl:param name="toc.section.depth" select="7"/>
	<xsl:param name="formal.title.placement">
	figure after
	</xsl:param>
	<!-- <xsl:param name="xep.extensions"  select="1"/> -->
	<!-- <xsl:param name="fop.extensions" select="'1'"/> -->
	<xsl:param name="use.svg" select="1"/>
	<xsl:param name="generate.toc">
	appendix	nop
	article		nop
	book		toc,title,figure,table,example
	chapter		nop
	part		nop
	preface		nop
	qandadiv	nop
	qandaset	nop
	reference	nop
	section		nop
	set			nop
	</xsl:param>
	<!-- title font size -->
	<xsl:attribute-set name="book.titlepage.recto.style">
		<xsl:attribute name="font-size">14pt</xsl:attribute>
	</xsl:attribute-set>
	<!-- each section starts on a new page -->
	<xsl:attribute-set name="section.title.level1.properties">
		<!-- <xsl:attribute name="break-before">page</xsl:attribute> -->
		<xsl:attribute name="font-size">14pt</xsl:attribute>
	</xsl:attribute-set>
	<!-- 2nd level section font size -->
	<xsl:attribute-set name="section.title.level2.properties">
		<xsl:attribute name="font-size">12pt</xsl:attribute>
	</xsl:attribute-set>
	<!-- admonition style -->
	<xsl:attribute-set name="admonition.title.properties">
		<xsl:attribute name="font-size">9pt</xsl:attribute>
	</xsl:attribute-set>

	<!-- Need to customize watermark image inclusion, since this doesn't work unless we copy it
	     here from xhtml/docbook.xsl (no idea why; didn't change it, but this prevents the pMML2SVG
		 adding suprious CDATA wrapper that prevents browser from using it) -->
	<!-- While we are customizing, might as well activate background repeat vertically (but not horizontally) and center -->
<xsl:template name="head.content.style">
  <xsl:param name="node" select="."/>
  <style type="text/css"><xsl:text>
body { background-image: url('</xsl:text>
<xsl:value-of select="$draft.watermark.image"/><xsl:text>');
       background-repeat: repeat-y;
       background-position: center;
       /* The following properties make the watermark "fixed" on the page. */
       /* I think that's just a bit too distracting for the reader... */
       /* background-attachment: fixed; */
       /* background-position: center center; */
     }</xsl:text>
    </style>
</xsl:template>

<!-- provide access to label attribute of glossdiv and bibliodiv (similar to mechanism in common/labels.xsl) -->

<xsl:template match="d:glossdiv|d:bibliodiv" mode="label.markup">
      <xsl:value-of select="@label"/>
</xsl:template>

<!-- create a glossdiv and bibliodiv specific template to override the default in common/gentext.xsl that does not number these ever -->
<xsl:template match="d:glossdiv|d:bibliodiv"
              mode="object.title.template">

      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-numbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    
</xsl:template>

<!-- Unlike with FO, there is a specific template to match these that normally generates an h3 and nothing else; need to override these and make component.title in xhtml/component.xsl do the work using the gentext mechanism customized above -->
<xsl:template match="d:glossdiv/d:title|d:bibliodiv/d:title">
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="component.title">
		<xsl:with-param name="node" select=".."/>
	</xsl:call-template>
</xsl:template>

<!-- per example in "http://www.sagehill.net/docbookxsl/HTMLHeaders.html", include breadcrumbs in header -->

<xsl:template name="breadcrumbs">
  <xsl:param name="this.node" select="."/>
  <div class="breadcrumbs">
    <xsl:for-each select="$this.node/ancestor::*">
      <span class="breadcrumb-link">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="object" select="."/>
              <xsl:with-param name="context" select="$this.node"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:apply-templates select="." mode="title.markup"/>
        </a>
      </span>
      <xsl:text> &gt; </xsl:text>
    </xsl:for-each>
    <!-- And display the current node, but not as a link -->
    <span class="breadcrumb-node">
      <xsl:apply-templates select="$this.node" mode="title.markup"/>
    </span>
  </div>
</xsl:template>

<xsl:template name="user.header.content">
  <xsl:call-template name="breadcrumbs"/>
</xsl:template>

<!-- include full name and release of part on every page before the navigation headers and after the navigation footers -->

<xsl:template name="user.header.navigation">
	<table width="100%">
		<tr>
			<th colspan="1" align="center" rowspan="1">
				<span class="documentreleaseinformation">
					<xsl:value-of select="/d:book/d:subtitle"/>
				</span>
			</th>
		</tr>
	</table>
</xsl:template>

<xsl:template name="user.footer.navigation">
	<table width="100%">
		<tr>
			<th colspan="1" align="center" rowspan="1">
				<span class="documentreleaseinformation">
					<xsl:value-of select="/d:book/d:subtitle"/>
				</span>
			</th>
		</tr>
	</table>
</xsl:template>

    <!-- add link to current release in header center navigation cell - customize templates from chunk-common.xsl-->
    
    <xsl:template name="header.navigation">
        <xsl:param name="prev" select="/d:foo"/>
        <xsl:param name="next" select="/d:foo"/>
        <xsl:param name="nav.context"/>
        
        <xsl:variable name="home" select="/*[1]"/>
        <xsl:variable name="up" select="parent::*"/>
        
        <xsl:variable name="row1" select="$navig.showtitles != 0"/>
        <xsl:variable name="row2" select="count($prev) &gt; 0
            or (count($up) &gt; 0 
            and generate-id($up) != generate-id($home)
            and $navig.showtitles != 0)
            or count($next) &gt; 0"/>
        
        <xsl:variable name="parttitle" select="/d:book/d:title"/>
        <xsl:variable name="partnumber" select="substring-after($parttitle,'PS3.')"/>
        <xsl:variable name="zeropaddedpartnumber">
            <xsl:choose>
                <xsl:when test="string-length($partnumber) = 1"><xsl:text>0</xsl:text><xsl:value-of select="$partnumber"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$partnumber"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$suppress.navigation = '0' and $suppress.header.navigation = '0'">
            <div class="navheader">
                <xsl:if test="$row1 or $row2">
                    <table width="100%" summary="Navigation header">
                        <xsl:if test="$row1">
                            <tr>
                                <th colspan="3" align="center">
                                    <xsl:apply-templates select="." mode="object.title.markup"/>
                                    <xsl:text> </xsl:text>
                                    <a accesskey="current">
                                        <xsl:attribute name="href">
                                            <xsl:text>http://dicom.nema.org/medical/dicom/current/output/chtml/part</xsl:text>
                                            <xsl:value-of select="$zeropaddedpartnumber"/>
                                            <xsl:text>/</xsl:text>
                                            <xsl:call-template name="href.target">
                                                <xsl:with-param name="object" select="."/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                        <xsl:text>(Current)</xsl:text>
                                    </a>
                                </th>
                            </tr>
                        </xsl:if>
                        
                        <xsl:if test="$row2">
                            <tr>
                                <td width="20%" align="{$direction.align.start}">
                                    <xsl:if test="count($prev)>0">
                                        <a accesskey="p">
                                            <xsl:attribute name="href">
                                                <xsl:call-template name="href.target">
                                                    <xsl:with-param name="object" select="$prev"/>
                                                </xsl:call-template>
                                            </xsl:attribute>
                                            <xsl:call-template name="navig.content">
                                                <xsl:with-param name="direction" select="'prev'"/>
                                            </xsl:call-template>
                                        </a>
                                    </xsl:if>
                                    <xsl:text>&#160;</xsl:text>
                                </td>
                                <th width="60%" align="center">
                                    <xsl:choose>
                                        <xsl:when test="count($up) > 0
                                            and generate-id($up) != generate-id($home)
                                            and $navig.showtitles != 0">
                                            <xsl:apply-templates select="$up" mode="object.title.markup"/>
                                        </xsl:when>
                                        <xsl:otherwise>&#160;</xsl:otherwise>
                                    </xsl:choose>
                                </th>
                                <td width="20%" align="{$direction.align.end}">
                                    <xsl:text>&#160;</xsl:text>
                                    <xsl:if test="count($next)>0">
                                        <a accesskey="n">
                                            <xsl:attribute name="href">
                                                <xsl:call-template name="href.target">
                                                    <xsl:with-param name="object" select="$next"/>
                                                </xsl:call-template>
                                            </xsl:attribute>
                                            <xsl:call-template name="navig.content">
                                                <xsl:with-param name="direction" select="'next'"/>
                                            </xsl:call-template>
                                        </a>
                                    </xsl:if>
                                </td>
                            </tr>
                        </xsl:if>
                    </table>
                </xsl:if>
                <xsl:if test="$header.rule != 0">
                    <hr/>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>

<!-- do not italicize foreignphrase -->
<xsl:template match="d:foreignphrase">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <!--<xsl:call-template name="inline.italicseq"/>-->
    <xsl:call-template name="inline.charseq"/>
  </span>
</xsl:template>

</xsl:stylesheet>
