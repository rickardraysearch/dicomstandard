<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                version='1.0'>
	<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/>

	<!-- This parameter should control PDF bookmarks initial state, and is supposed to in FOP, and is used in fop1.xsl; see "http://docbook.sourceforge.net/release/xsl/current/doc/fo/bookmarks.collapse.html" -->
	<xsl:param name="bookmarks.collapse" select="1"></xsl:param>

	<!-- Need to customize xep.xsl template to do the same as fop1.xsl wrt. bookmarks.collapse -->
	<!-- See also (obsolete) discussion at "https://lists.oasis-open.org/archives/docbook-apps/200903/msg00195.html" -->
	<!-- See also "https://lists.oasis-open.org/archives/docbook-apps/201309/msg00071.html" -->
	<!-- See also RenderX User Manual that discusses the "starting-state" attribute and its evolution -->
	<!-- Note that this customization means that the rx namespace needs to be defined in xsl:stylesheet -->
	
<xsl:variable name="bookmarks.state">
  <xsl:choose>
    <xsl:when test="$bookmarks.collapse != 0">hide</xsl:when>
    <xsl:otherwise>show</xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:template match="set|book|part|reference|preface|chapter|appendix|article
                     |glossary|bibliography|index|setindex|topic
                     |refentry|refsynopsisdiv
                     |refsect1|refsect2|refsect3|refsection
                     |sect1|sect2|sect3|sect4|sect5|section"
              mode="xep.outline">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="bookmark-label">
    <xsl:apply-templates select="." mode="object.title.markup"/>
  </xsl:variable>

  <!-- Put the root element bookmark at the same level as its children -->
  <!-- If the object is a set or book, generate a bookmark for the toc -->
  <xsl:choose>
    <xsl:when test="self::index and $generate.index = 0"/>	
    <xsl:when test="parent::*">
      <rx:bookmark internal-destination="{$id}">
	<xsl:attribute name="starting-state">
	  <xsl:value-of select="$bookmarks.state"/>
	</xsl:attribute>
        <rx:bookmark-label>
          <xsl:value-of select="normalize-space($bookmark-label)"/>
        </rx:bookmark-label>
        <xsl:apply-templates select="*" mode="xep.outline"/>
      </rx:bookmark>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$bookmark-label != ''">
        <rx:bookmark internal-destination="{$id}">
	<xsl:attribute name="starting-state">
	  <xsl:value-of select="$bookmarks.state"/>
	</xsl:attribute>
          <rx:bookmark-label>
            <xsl:value-of select="normalize-space($bookmark-label)"/>
          </rx:bookmark-label>
        </rx:bookmark>
      </xsl:if>

      <xsl:variable name="toc.params">
        <xsl:call-template name="find.path.params">
          <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="contains($toc.params, 'toc')
                    and set|book|part|reference|section|sect1|refentry
                        |article|topic|bibliography|glossary|chapter
                        |appendix">
        <rx:bookmark internal-destination="toc...{$id}">
          <rx:bookmark-label>
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="'TableofContents'"/>
            </xsl:call-template>
          </rx:bookmark-label>
        </rx:bookmark>
      </xsl:if>
      <xsl:apply-templates select="*" mode="xep.outline"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- do not italicize foreignphrase -->
<xsl:template match="d:foreignphrase">
  <!--<xsl:call-template name="inline.italicseq"/>-->
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

</xsl:stylesheet>
