<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:d="http://docbook.org/ns/docbook"
	exclude-result-prefixes="d"
  	version="1.0">

<xsl:strip-space elements="*" />

<xsl:output omit-xml-declaration="no" method="xml" indent="yes" encoding="UTF-8" />

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:template match="d:book[@label = 'PS3.16']">
	<book>
		<xsl:apply-templates match=""/>
	</book>
</xsl:template>


<xsl:template match="d:table[@xml:id='table_D-1']">
	<!--<xsl:message>Processing Table D-1</xsl:message>-->
	<chapter label="D" status="1" xml:id="chapter_D">
		<title>DICOM Controlled Terminology Definitions (Normative)</title>
		<table rules="all" frame="box" label="D-1" xml:id="table_D-1">
			<caption>DICOM Controlled Terminology Definitions</caption>
      <thead>
        <tr valign="top">
          <th align="center" colspan="1" rowspan="1">
            <para>
              <emphasis role="bold">Code Value</emphasis>
            </para>
          </th>
          <th align="center" colspan="1" rowspan="1">
            <para>
              <emphasis role="bold">Code Meaning</emphasis>
            </para>
          </th>
          <th align="center" colspan="1" rowspan="1">
            <para>
              <emphasis role="bold">Definition</emphasis>
            </para>
          </th>
          <th align="center" colspan="1" rowspan="1">
            <para>
              <emphasis role="bold">Notes</emphasis>
            </para>
          </th>
        </tr>
      </thead>
	  <tbody>
			
	<xsl:if test="d:thead/d:tr/d:th[1] = 'Code Value'
              and d:thead/d:tr/d:th[2] = 'Code Meaning'
              and d:thead/d:tr/d:th[3] = 'Definition'
              and d:thead/d:tr/d:th[4] = 'Notes'">
		<xsl:for-each select="d:tbody/d:tr">
			<xsl:if test="count(d:td) = 4">
				<xsl:variable name="codeValue"><xsl:value-of select="normalize-space(d:td[1])"/></xsl:variable>
				<xsl:variable name="codeMeaning"><xsl:value-of select="normalize-space(d:td[2])"/></xsl:variable>
				<xsl:variable name="definition"><xsl:value-of select="normalize-space(d:td[3])"/></xsl:variable>
				<xsl:variable name="notes"><xsl:value-of select="normalize-space(d:td[4])"/></xsl:variable>

				<!--<xsl:message>Processing <xsl:value-of select="$codeValue"/>: <xsl:value-of select="$codeMeaning"/></xsl:message>-->
				<!--<xsl:message>   definition = "<xsl:value-of select="$definition"/>"</xsl:message>-->
				<!--<xsl:message>   notes = "<xsl:value-of select="$notes"/>"</xsl:message>-->
				
				<xsl:choose>
					<xsl:when test="$codeValue != ''">
							<xsl:choose>
								<xsl:when test="$codeMeaning != ''">
								</xsl:when>
								<xsl:otherwise>
									<xsl:message>Error: empty meaning for code: <xsl:value-of select="$codeValue"/></xsl:message>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="$definition = ''">
								<!--<xsl:message>No definition for code: <xsl:value-of select="$codeValue"/></xsl:message>-->
        <tr valign="top">
          <td align="center" colspan="1" rowspan="1">
            <para>
				<xsl:attribute name="id" namespace="http://www.w3.org/XML/1998/namespace">
					<xsl:text>DCM_</xsl:text><xsl:value-of select="$codeValue"/>
				</xsl:attribute>
				<xsl:value-of select="$codeValue"/>
			</para>
          </td>
          <td align="left" colspan="1" rowspan="1">
            <para><xsl:value-of select="$codeMeaning"/></para>
          </td>
          <td align="left" colspan="1" rowspan="1">
            <para><emphasis role="bold"><emphasis role="underline"></emphasis></emphasis></para>
          </td>
          <td align="left" colspan="1" rowspan="1">
            <para><xsl:value-of select="$notes"/></para>
          </td>
        </tr>
								
							</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message>Error: empty code value for meaning: <xsl:value-of select="$codeMeaning"/></xsl:message>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:if>
	
	  </tbody>
	
	</table>
	
	</chapter>
</xsl:template>

<xsl:template match="node()|@*">
		<xsl:apply-templates match=""/>
</xsl:template>

</xsl:stylesheet>
