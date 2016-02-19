<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:d="http://docbook.org/ns/docbook"
	xmlns="http://www.pixelmed.com/namespaces/contextgroups"
	exclude-result-prefixes="d"
  	version="1.0">

<xsl:strip-space elements="*" />

<xsl:output omit-xml-declaration="no" method="xml" indent="yes" encoding="UTF-8" />

<xsl:template match="d:book">
	<xsl:message>Matching book</xsl:message>
	<definetemplates
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xmlns="http://www.pixelmed.com/namespaces/contextgroups"
			xsi:schemaLocation="http://www.pixelmed.com/namespaces/contextgroups http://www.pixelmed.com/schemas/contextgroups.xsd">
		<xsl:apply-templates match=""/>
	</definetemplates>
</xsl:template>

<!-- do not want to match Section 7 explanatory tables -->
<xsl:template match="d:table[@label[starts-with(.,'TID ')] and not(@label[contains(.,'&lt;')]) and not(d:caption='Parameters')]">
	<xsl:message>Template <xsl:value-of select="@label"/></xsl:message>
	<xsl:variable name="extensible">
		<xsl:choose>
		<xsl:when test="starts-with(../d:variablelist/d:varlistentry[d:term='Type:']/d:listitem,'Non')">F</xsl:when>
		<xsl:otherwise>T</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="ordersignificant">
		<xsl:choose>
		<xsl:when test="starts-with(../d:variablelist/d:varlistentry[d:term='Order:']/d:listitem,'Non')">F</xsl:when>
		<xsl:otherwise>T</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="root">
		<xsl:choose>
		<xsl:when test="starts-with(../d:variablelist/d:varlistentry[d:term='Root:']/d:listitem,'Yes')">T</xsl:when>
		<xsl:otherwise>F</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="d:thead/d:tr/d:th[1] = ''
				    and d:thead/d:tr/d:th[2] = 'NL'
				    and d:thead/d:tr/d:th[3] = 'Rel with Parent'
				    and d:thead/d:tr/d:th[4] = 'VT'
				    and d:thead/d:tr/d:th[5] = 'Concept Name'
				    and d:thead/d:tr/d:th[6] = 'VM'
				    and d:thead/d:tr/d:th[7] = 'Req Type'
				    and d:thead/d:tr/d:th[8] = 'Condition'
				    and d:thead/d:tr/d:th[9] = 'Value Set Constraint'">
			<definetemplate
				tid="{substring(@label,5)}"
				name="{translate(d:caption,' -','')}"
				root="{$root}"
				extensible="{$extensible}"
				ordersignificant="{$ordersignificant}">
				
				<!-- process only top level content items, since each will then iterate through its own children, and so on recursively -->
				<xsl:for-each select="d:tbody/d:tr[string-length(normalize-space(d:td[2])) = 0]">
					<xsl:apply-templates select="." mode="groupnestinglevels"/>
				</xsl:for-each>
				
			</definetemplate>
		</xsl:when>
		<xsl:when test="d:thead/d:tr/d:th[1] = ''
				    and d:thead/d:tr/d:th[2] = 'NL'
				    and d:thead/d:tr/d:th[3] = 'VT'
				    and d:thead/d:tr/d:th[4] = 'Concept Name'
				    and d:thead/d:tr/d:th[5] = 'VM'
				    and d:thead/d:tr/d:th[6] = 'Req Type'
				    and d:thead/d:tr/d:th[7] = 'Condition'
				    and d:thead/d:tr/d:th[8] = 'Value Set Constraint'">
		</xsl:when>
		<xsl:when test="d:thead/d:tr/d:th[1] = ''
				    and d:thead/d:tr/d:th[2] = 'VT'
				    and d:thead/d:tr/d:th[3] = 'Concept Name'
				    and d:thead/d:tr/d:th[4] = 'VM'
				    and d:thead/d:tr/d:th[5] = 'Req Type'
				    and d:thead/d:tr/d:th[6] = 'Condition'
				    and d:thead/d:tr/d:th[7] = 'Value Set Constraint'">
		</xsl:when>
		<xsl:otherwise>
			<xsl:message>No heading match <xsl:value-of select="@label"/></xsl:message>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="cleanAndExpandReferencesInValueSetConstraint">
	<xsl:param name="element"/>
	<!-- element is <td/> containing either one or more <para/> and within them one or more <d:xref/> with @linkend of form 'sect_CID_nnn', but may also be emphasis, etc.-->
	<xsl:variable name="v">
		<xsl:for-each select="$element/d:para">
			<xsl:for-each select="child::node()">	<!-- NOT just '*', which matches only elements and not text() nodes -->
				<xsl:choose>
					<xsl:when test="name(.) = 'xref'">
						<xsl:text>CID </xsl:text><xsl:value-of select="normalize-space(substring-after(@linkend,'sect_CID_'))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<xsl:if test="following-sibling::d:para">
				<xsl:text>, </xsl:text> <!-- want a separator between paragraphs -->
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<xsl:value-of select="normalize-space($v)"/>
</xsl:template>

<xsl:template match="d:tr" mode="groupnestinglevels">
	<xsl:variable name="row"><xsl:value-of select="d:td[1]"/></xsl:variable>
	<xsl:if test="name(parent::node()) = 'tbody' and $row != ''">	<!-- untidy way to check not header, but it works :(; also excludes unlabelled rows-->
		<xsl:variable name="ourNestingLevel"><xsl:value-of select="string-length(normalize-space(d:td[2]))"/></xsl:variable>
		<xsl:variable name="relationship"><xsl:value-of select="normalize-space(d:td[3])"/></xsl:variable>
		<xsl:variable name="valueType"><xsl:value-of select="normalize-space(d:td[4])"/></xsl:variable>
		<xsl:variable name="conceptName"><xsl:value-of select="normalize-space(d:td[5])"/></xsl:variable>
		<xsl:variable name="vm"><xsl:value-of select="normalize-space(d:td[6])"/></xsl:variable>
		<xsl:variable name="requiredType"><xsl:value-of select="normalize-space(d:td[7])"/></xsl:variable>
		<xsl:variable name="condition"><xsl:value-of select="normalize-space(d:td[8])"/></xsl:variable>
		<xsl:variable name="valueSetConstraint"><xsl:value-of select="normalize-space(d:td[9])"/></xsl:variable>
		
		<xsl:variable name="vmmin">
			<xsl:choose>
				<xsl:when test="contains($vm,'-')">
					 <xsl:value-of select="substring-before($vm,'-')"/>
				</xsl:when>
				<xsl:otherwise>
					 <xsl:value-of select="$vm"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="vmmax">
			<xsl:choose>
				<xsl:when test="contains($vm,'-')">
					 <xsl:value-of select="substring-after($vm,'-')"/>
				</xsl:when>
				<xsl:otherwise>
					 <xsl:value-of select="$vm"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<!--<xsl:variable name="followingNestingLevel"><xsl:value-of select="string-length(normalize-space(following-sibling::d:tr/d:td[2]))"/></xsl:variable>-->
		<!--<xsl:message>TR row = <xsl:value-of select="$row"/>,  ourNestingLevel = <xsl:value-of select="$ourNestingLevel"/>,  followingNestingLevel = <xsl:value-of select="$followingNestingLevel"/></xsl:message>-->

		<xsl:choose>
			<xsl:when test="$valueType = 'INCLUDE'">
				<xsl:variable name="includeTID">
					<xsl:choose>
						<xsl:when test="d:td[5]/d:para/d:xref">
							<xsl:value-of select="normalize-space(substring-after(d:td[5]/d:para/d:xref/@linkend,'sect_TID_'))"/>	<!-- all PS 3.16 entries should be of this form -->
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space(substring-before(substring-after(d:td[5],'TID'),'&quot;'))"/>		<!-- may occur in CPs or supplements that are not hyperlinked - depends on title being quoted :( -->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<includetemplate row="{$row}" tid="{$includeTID}" relationship="{$relationship}" vmmin="{$vmmin}" vmmax="{$vmmax}" requiredType="{$requiredType}"/>
				
				<xsl:variable name="cleanedValueSetConstraint">
					<!--<xsl:value-of select="$valueSetConstraint"/>-->
					<xsl:call-template name="cleanAndExpandReferencesInValueSetConstraint">
						<xsl:with-param name="element" select="d:td[9]"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$cleanedValueSetConstraint != ''">
					<xsl:comment><xsl:value-of select="$cleanedValueSetConstraint"/></xsl:comment>
				</xsl:if>

				<xsl:if test="$condition != ''">
					<xsl:comment><xsl:value-of select="$condition"/></xsl:comment>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<templatecontentitem>
				
					<!-- take care to add all attributes of templatecontentitem BEFORE any (other) children else run time error executing xslt -->
					
					<xsl:attribute name="row"><xsl:value-of select="$row"/></xsl:attribute>
					<xsl:attribute name="relationship"><xsl:value-of select="$relationship"/></xsl:attribute>
					<xsl:attribute name="valueType"><xsl:value-of select="$valueType"/></xsl:attribute>
					<xsl:attribute name="vmmin"><xsl:value-of select="$vmmin"/></xsl:attribute>
					<xsl:attribute name="vmmax"><xsl:value-of select="$vmmax"/></xsl:attribute>
					<xsl:attribute name="requiredType"><xsl:value-of select="$requiredType"/></xsl:attribute>

					<xsl:variable name="conceptNameCID">
						<xsl:choose>
							<xsl:when test="d:td[5]/d:para/d:xref">
								<xsl:value-of select="normalize-space(substring-after(d:td[5]/d:para/d:xref/@linkend,'sect_CID_'))"/>	<!-- all PS 3.16 entries should be of this form -->
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="normalize-space(substring-before(substring-after(d:td[5],'CID'),'&quot;'))"/>		<!-- may occur in CPs or supplements that are not hyperlinked - depends on title being quoted :( -->
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
							
					<xsl:choose>
						<xsl:when test="starts-with($conceptName,'EV') or starts-with($conceptName,'DT')">	<!-- do not need to worry about "DTID", since that only occurs with INCLUDE handled elsewhere -->
							<xsl:variable name="tupleForConceptName">
								<xsl:choose>
									<xsl:when test="starts-with($conceptName,'EV')">
										<xsl:value-of select="normalize-space(substring-after($conceptName,'EV'))"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="normalize-space(substring-after($conceptName,'DT'))"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="cvConceptName"><xsl:value-of select="normalize-space(substring-before(substring-after($tupleForConceptName,'('),','))"/></xsl:variable>
							<xsl:variable name="remainderConceptNameAfterCV"><xsl:value-of select="normalize-space(substring-after(substring-after($tupleForConceptName,'('),','))"/></xsl:variable>
							<xsl:variable name="csdConceptName"><xsl:value-of select="normalize-space(substring-before($remainderConceptNameAfterCV,','))"/></xsl:variable>
							<xsl:variable name="remainderConceptNameAfterCSD"><xsl:value-of select="normalize-space(substring-after($remainderConceptNameAfterCV,','))"/></xsl:variable>
							<xsl:variable name="cmConceptName"><xsl:value-of select="normalize-space(translate(substring-before($remainderConceptNameAfterCSD,')'),'&quot;',''))"/></xsl:variable>
							<xsl:attribute name="cvConceptName"><xsl:value-of select="$cvConceptName"/></xsl:attribute>
							<xsl:attribute name="csdConceptName"><xsl:value-of select="$csdConceptName"/></xsl:attribute>
							<xsl:attribute name="cmConceptName"><xsl:value-of select="$cmConceptName"/></xsl:attribute>
							
						</xsl:when>
						<xsl:when test="(starts-with($conceptName,'B') or starts-with($conceptName,'D') or starts-with($conceptName,'E')) and $conceptNameCID != ''">	<!-- do not think we actually ever encounter 'E' -->
							<!--<xsl:message>B/D/ECID = <xsl:value-of select="$conceptNameCID"/></xsl:message>-->
							<xsl:attribute name="conceptNameCID"><xsl:value-of select="$conceptNameCID"/></xsl:attribute>
							<xsl:attribute name="conceptNameBDE"><xsl:value-of select="substring($conceptName,1,1)"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:variable name="numberOfUnits"><xsl:value-of select="count(d:td[9]/d:para[starts-with(.,'UNITS') and not(contains(.,'&#36;'))])"/></xsl:variable>	<!-- i.e., just one, and not a parameter -->
					<xsl:choose>
						<xsl:when test="$numberOfUnits = 1">
							<xsl:choose>
								<xsl:when test="starts-with(d:td[9]/d:para[starts-with(.,'UNITS') and not(contains(.,'&#36;'))][1]/d:xref/@linkend,'sect_CID_')">
									<xsl:attribute name="unitsCID"><xsl:value-of select="normalize-space(substring-after(d:td[9]/d:para[starts-with(.,'UNITS') and not(contains(.,'&#36;'))][1]/d:xref/@linkend,'sect_CID_'))"/></xsl:attribute>
									<xsl:attribute name="unitsBDE"><xsl:value-of select="substring(normalize-space(substring-after(d:td[9]/d:para[starts-with(.,'UNITS') and not(contains(.,'&#36;'))][1],'=')),1,1)"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="tupleForUnits"><xsl:value-of select="d:td[9]/d:para[starts-with(.,'UNITS') and not(contains(.,'&#36;'))][1]"/></xsl:variable>
									<xsl:variable name="cvUnits"><xsl:value-of select="normalize-space(substring-before(substring-after($tupleForUnits,'('),','))"/></xsl:variable>
									<xsl:variable name="remainderUnitsAfterCV"><xsl:value-of select="normalize-space(substring-after(substring-after($tupleForUnits,'('),','))"/></xsl:variable>
									<xsl:variable name="csdUnits"><xsl:value-of select="normalize-space(substring-before($remainderUnitsAfterCV,','))"/></xsl:variable>
									<xsl:variable name="remainderUnitsAfterCSD"><xsl:value-of select="normalize-space(substring-after($remainderUnitsAfterCV,','))"/></xsl:variable>
									<xsl:variable name="cmUnits"><xsl:value-of select="normalize-space(translate(substring-before($remainderUnitsAfterCSD,')'),'&quot;',''))"/></xsl:variable>
									<xsl:attribute name="cvUnits"><xsl:value-of select="$cvUnits"/></xsl:attribute>
									<xsl:attribute name="csdUnits"><xsl:value-of select="$csdUnits"/></xsl:attribute>
									<xsl:attribute name="cmUnits"><xsl:value-of select="$cmUnits"/></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:variable name="numberOfValueSetCIDs"><xsl:value-of select="count(d:td[9]/d:para[(starts-with(.,'B') or starts-with(.,'D') or starts-with(.,'E')) and contains(d:xref/@linkend,'sect_CID_')])"/></xsl:variable>
					<xsl:variable name="numberOfValues"><xsl:value-of select="count(d:td[9]/d:para[starts-with(.,'EV') or starts-with(.,'DT')])"/></xsl:variable>
					<xsl:choose>
						<xsl:when test="$numberOfValueSetCIDs = 1 and $numberOfValues = 0">
							<xsl:attribute name="valueSetCID"><xsl:value-of select="normalize-space(substring-after(d:td[9]/d:para[(starts-with(.,'B') or starts-with(.,'D') or starts-with(.,'E')) and contains(d:xref/@linkend,'sect_CID_')][1]/d:xref/@linkend,'sect_CID_'))"/></xsl:attribute>
							<xsl:attribute name="valueSetBDE"><xsl:value-of select="substring(normalize-space(d:td[9]/d:para[(starts-with(.,'B') or starts-with(.,'D') or starts-with(.,'E')) and contains(d:xref/@linkend,'sect_CID_')][1]),1,1)"/></xsl:attribute>
						</xsl:when>
						<xsl:when test="$numberOfValueSetCIDs = 0 and $numberOfValues = 1">
							<xsl:variable name="tupleForValue">
								<xsl:choose>
									<xsl:when test="starts-with(d:td[9]/d:para[starts-with(.,'EV') or starts-with(.,'DT')][1],'EV')">
										<xsl:value-of select="normalize-space(substring-after(d:td[9]/d:para[starts-with(.,'EV') or starts-with(.,'DT')][1],'EV'))"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="normalize-space(substring-after(d:td[9]/d:para[starts-with(.,'EV') or starts-with(.,'DT')][1],'DT'))"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="cvValue"><xsl:value-of select="normalize-space(substring-before(substring-after($tupleForValue,'('),','))"/></xsl:variable>
							<xsl:variable name="remainderValueAfterCV"><xsl:value-of select="normalize-space(substring-after(substring-after($tupleForValue,'('),','))"/></xsl:variable>
							<xsl:variable name="csdValue"><xsl:value-of select="normalize-space(substring-before($remainderValueAfterCV,','))"/></xsl:variable>
							<xsl:variable name="remainderValueAfterCSD"><xsl:value-of select="normalize-space(substring-after($remainderValueAfterCV,','))"/></xsl:variable>
							<xsl:variable name="cmValue"><xsl:value-of select="normalize-space(translate(substring-before($remainderValueAfterCSD,')'),'&quot;',''))"/></xsl:variable>
							<xsl:attribute name="cvValue"><xsl:value-of select="$cvValue"/></xsl:attribute>
							<xsl:attribute name="csdValue"><xsl:value-of select="$csdValue"/></xsl:attribute>
							<xsl:attribute name="cmValue"><xsl:value-of select="$cmValue"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>

					<!-- all attributes done now ... add other children prn. -->
					
					<xsl:variable name="cleanedValueSetConstraint">
						<xsl:choose>
							<xsl:when test="count(d:td[9]/d:para) = 1 and ($numberOfValueSetCIDs = 1 or $numberOfValueSetCIDs = 0 or $numberOfUnits = 1)">
								<!-- empty since information already decoded into attributes -->
							</xsl:when>
							<xsl:otherwise>
								<!--<xsl:value-of select="$valueSetConstraint"/>-->
								<xsl:call-template name="cleanAndExpandReferencesInValueSetConstraint">
									<xsl:with-param name="element" select="d:td[9]"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="$cleanedValueSetConstraint != ''">
						<xsl:comment><xsl:value-of select="$cleanedValueSetConstraint"/></xsl:comment>
					</xsl:if>
		
					<xsl:if test="$condition != ''">
						<xsl:comment><xsl:value-of select="$condition"/></xsl:comment>
					</xsl:if>
		
					<!-- now recurse through all our immediate (only) children, so that they are enclosed with this templatecontentitem node -->
					<!--<xsl:message>Parent is <xsl:value-of select="preceding-sibling::d:tr[string-length(normalize-space(d:td[2])) &lt; string-length(normalize-space(current()/d:td[2]))][1]/d:td[1]"/></xsl:message>-->
					<!-- for-each d:tr that is an immediate child AND whose parent is us -->
					<xsl:variable name="ourid"><xsl:value-of select="generate-id(.)"/></xsl:variable>
					<xsl:for-each select="following-sibling::d:tr[string-length(normalize-space(d:td[2])) = ($ourNestingLevel + 1) and generate-id(preceding-sibling::d:tr[string-length(normalize-space(d:td[2])) = $ourNestingLevel][1]) = $ourid]">
						<!--<xsl:message>Have child row <xsl:value-of select="d:td[1]"/></xsl:message>-->
						<xsl:apply-templates select="." mode="groupnestinglevels"/>
					</xsl:for-each>
					<!--<xsl:message>Closing row</xsl:message>-->
				</templatecontentitem>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

<xsl:template match="node()|@*|">
		<xsl:apply-templates match=""/>
</xsl:template>

<xsl:template match="text()"/>

</xsl:stylesheet>
