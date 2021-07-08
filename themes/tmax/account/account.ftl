<#import "template.ftl" as layout>
<@layout.mainLayout active='account' bodyClass='user'; section>
    <div id="account-update" class="">
        <@layout.contentHeader required=false; section>
            ${msg("editAccountHtmlTitle")}
        </@layout.contentHeader>
        </br>
        ${msg("editAccountHtmlBody")}
        </br>
        <hr>
        <input type="hidden" id="originName" name="originName" value="${(account.userNameAttr!'')}">        
        <form id="account-update-form" action="${url.accountUrl}" class="form-horizontal" method="post">

            <input type="hidden" id="stateChecker" name="stateChecker" value="${stateChecker}">

            <#if !realm.registrationEmailAsUsername>
                <@layout.formGroup key="username" required=false formGroupClass="${messagesPerField.printIfExists('username','has-error')}">
                    <input type="text" class="form-control" id="username" name="username" <#if !realm.editUsernameAllowed>disabled="disabled"</#if> value="${(account.username!'')}"/>
                </@layout.formGroup>
            </#if>

            <@layout.formGroup key="email" required=false formGroupClass="${messagesPerField.printIfExists('email','has-error')}">
                <input type="text" class="form-control" id="email" name="email" value="${(account.email!'')}" disabled="disabled" />
            </@layout.formGroup>

            <@layout.formGroup key="userNameAttr" required=false formGroupClass="${messagesPerField.printIfExists('userNameAttr','has-error')}">
                <input type="text" class="form-control" id="userNameAttr" name="userNameAttr" autofocus value="${(account.userNameAttr!'')}" onkeyup="buttonAbled(); return false" maxlength="50"/>
            </@layout.formGroup>
            <div class="${properties.kcInputWrapperClass!} error_message" id="error_username_empty" style="display: none">
                ${msg("MSG_ERROR_USERNAME_1")}
            </div>
            <div class="${properties.kcInputWrapperClass!} error_message" id="error_username_over" style="display: none">
                ${msg("MSG_ERROR_USERNAME_2")}
            </div>
            <div class="${properties.kcInputWrapperClass!} error_message" id="error_username_format" style="display: none">
                ${msg("MSG_ERROR_USERNAME_3")}
            </div>

<#--        <@layout.formGroup key="firstName" required=true formGroupClass="${messagesPerField.printIfExists('firstName','has-error')}">-->
<#--            <input type="text" class="form-control" id="firstName" name="firstName" value="${(account.firstName!'')}"/>-->
<#--        </@layout.formGroup>-->

<#--        <@layout.formGroup key="lastName" required=true formGroupClass="${messagesPerField.printIfExists('lastName','has-error')}">-->
<#--            <input type="text" class="form-control" id="lastName" name="lastName" value="${(account.lastName!'')}"/>-->
<#--        </@layout.formGroup>-->
            <hr>            
            <p id="">
                ${msg("withdrawalHtmlBody")}
                <a href="#" onclick="openWithdrawalPage(); return false;">
                    ${msg("withdrawalAccount")}
                </a>
            </p>
            <br>
            
            <@layout.formButtonGroup>
                <#if url.referrerURI??><a href="${(url.referrerURI!'')}">${kcSanitize(msg("backToApplication")?no_esc)}</a></#if>
                <div id="buttons">            
                    <button class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!} ${properties.kcButtonLargeClass!}" onclick="openCancelModal(); return false;">${msg("doCancel")}</button>
                    <button id="account-save-button" class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}" onclick="changeName(); return false;" disabled>${msg("doSave")}</button>            
                </div>
            </@layout.formButtonGroup>

            <!--
            <div id="account-save">
                <div class="saveModal hidden">
                    <div class="md_overlay"></div>
                    <div class="md_content">
                        <div class="md_content__header">
                            <span class="md_content__header__title">
                                ${msg("accountSaveModalTitle")}
                            </span>
                            <span class="md_content__header__close" onclick="closeSaveModal()"></span>
                        </div>
                        <hr>
                        <div class="md_content__text">
                            ${msg("accountSaveModalMessage")}
                        </div>
                        <div class="md_content__button">                        
                            <div id="button-ok" class="button modal_button_right" onclick="closeSaveModal()">
                                ${msg("doOK")}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            -->            
            <div id="account-cancel">
                <div class="cancelModal hidden">
                    <div class="md_overlay"></div>
                    <div class="md_content">
                        <div class="md_content__header">
                            <span class="md_content__header__title">
                                ${msg("accountCancelModalTitle")}
                            </span>
                            <span class="md_content__header__close" onclick="closeCancelModal()"></span>
                        </div>
                        <hr>
                        <div class="md_content__text">
                            ${msg("accountCancelModalMessage")}
                            <br>
                            ${msg("accountCancelModalMessage2")}
                        </div>
                        <div class="md_content__button">
                            <div id="button-cancel" class="button modal_button_left" onclick="closeCancelModal()">
                                ${msg("doCancel")}
                            </div>
                            <div id="button-ok" class="button modal_button_right" onclick="cancelChangeName()">
                                ${msg("doOK")}
                            </div>
                        </div>
                    </div>
                </div>
            </div>            
        </form>        
    </div>

    <div id="withdrawal-step1" class="hidden">    
        <@layout.contentHeader required=false; section>
            ${msg("withdrawalTitle")}
        </@layout.contentHeader>
        <div>
        </br>
        ${msg("withdrawalStep1_Message")}
        </br>
        <hr>
        <div id="signout-logo">
            <p class="image"></p>             
        </div>
        <h3>${msg("withdrawalStep1_body1")}</h3>
        <h3>${msg("withdrawalStep1_body2")}</h3>
        <br>
        <p><a href="#" onclick="openAgreementModal(1); return false;">
            ${msg("withdrawalAcountAgreement")}
        </a></p>
        <p> | </p>
        <p><a href="#" onclick="openAgreementModal(2); return false;">
            ${msg("withdrawalServiceAgreement")}
        </a></p>        
        <hr>
        <@layout.formButtonGroup>
            <div id="buttons">
                <#if url.referrerURI??><a href="${(url.referrerURI!'')}">${kcSanitize(msg("backToApplication")?no_esc)}</a></#if>            
                <button class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!} ${properties.kcButtonLargeClass!}" onclick="closeWithdrawalPage(); return false;">${msg("doCancel")}</button>
                <button class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}" onclick="nextWithdrawalPage(); return false;">${msg("doNext")}</button>            
            </div>
        </@layout.formButtonGroup>
        </div>
        <div id="OneAccount-Agreement">        
            <div class="agreementModal hidden">          
                <div class="md_overlay"></div>
                <div class="md_content">
                    <div class="md_content__header">
                        <span id="account_terms_modal_title" class="md_content__header__title hidden">
                            ${msg("withdrawalAcountAgreementModalTitle")}
                        </span>
                        <span id="service_terms_modal_title" class="md_content__header__title hidden">
                            ${msg("withdrawalServiceAgreementModalTitle")}
                        </span>
                        <span class="md_content__header__close" onclick="cloaseAgreementModal()"></span>
                    </div>
                    <hr>
                    <div class="md_content__text">
                        <div class="content_text_title hidden" id="account_terms_title">${msg("withdrawalAcountAgreementModalTitle")}</div>
                        <div class="content_text_title hidden" id="service_terms_title">${msg("withdrawalServiceAgreementModalTitle")}</div>
                        <div class="term hidden" id="account_terms"></div>
                        <div class="term hidden" id="service_terms"></div>
                    </div>
                    <div class="md_content__button">                    
                        <div id="button-ok" class="button modal_button_right" onclick="cloaseAgreementModal()">
                            ${msg("doOK")}
                        </div>
                    </div>
                </div>
            </div>
        </div>        
    </div>    
    <div id="withdrawal-step2" class="hidden">    
        <@layout.contentHeader required=false; section>
            ${msg("withdrawalTitle")}
        </@layout.contentHeader>        
        </br>
        ${msg("withdrawalStep2_Message")}
        </br>
        <hr>

    
        <#assign withdrawalUrl = url.accountUrl?replace("^(.*)(/account/?)(\\?(.*))?$", "$1/console/withdrawal?$4", 'r') />
        <form id="withdrawal-form" action="${withdrawalUrl}" class="form-horizontal" method="post" enctype="multipart/form-data">

            <input type="hidden" id="stateChecker-withdrawal" name="stateChecker" value="${stateChecker}">
            <@layout.formGroup key="email" required=false formGroupClass="${messagesPerField.printIfExists('email','has-error')}">
                <input type="text" class="form-control" id="email-withdrawal" name="email" value="${(account.username!'')}" disabled="disabled" />
            </@layout.formGroup>


                <@layout.formGroup key="password" required=false formGroupClass="${messagesPerField.printIfExists('password','has-error')}">
                    <div>
                        <#if password.passwordSet>
                            <div class="passwordBox">
                                <input type="password" class="form-control" id="password" name="password" value="${(account.password!'')}" onkeyup="withdrawalSubmitButtonAbled(); return false"/>
                                <div id="eye-password" class="eye" onclick="clickEye(this)"></div>
                                <div class="${properties.kcInputWrapperClass!} error_message" id="error_password_empty" style="display: none">
                                    ${msg("MSG_ERROR_PASSWORD_EMPTY")}
                                </div>
                                <div class="${properties.kcInputWrapperClass!} error_message" id="error_password_wrong" style="display: none">
                                    ${msg("MSG_ERROR_PASSWORD_WRONG")}
                                </div>
                            </div>
                        </#if>
                        <#list federatedIdentity.identities as identity>
                        <#--  <@layout.formGroup key="${identity.providerId!}" labelText="${identity.displayName!}">  -->
                        <#--<input disabled="true" class="form-control" value="${identity.userName!}">-->
                            <#if identity.connected>
                                    <#if password.passwordSet>
                                        <div class="boundaryBox">
                                            <hr />
                                                <span class="text">${msg("or")}</span>
                                            <hr />
                                        </div>
                                    </#if>
            <#--                    <#if federatedIdentity.removeLinkPossible>-->
                                    <#if identity.displayName = 'kakao'>
                                    <#-- kakao api key를 hidden input으로 받는다.   -->
                                        <div class="snsBox kakao" onclick="loginWithKakao()">
                                            <input id="kakao-api-key" type="hidden" value="${(identity.kakaoJsKey!'')}">
                                            <a id="custom-login-btn" href="javascript:loginWithKakao()">
                                                <img
                                                        src="${url.resourcesPath}/img/btn_kakao_login.svg"
                                                        width="20"
                                                />
                                            </a>
                                            <span class="message kakao">KAKAO로 인증</span>
                                        </div>
                                    <#elseif identity.displayName = 'naver'>
                                        <div class="snsBox naver" onclick="">
                                            <div id="naver_id_login"></div>
                                            <span class="message naver">NAVER로 인증</span>
                                        </div>
                                    </#if>
            <#--                    </#if>-->
                            </#if>
                        <#--  </@layout.formGroup>  -->
                        </#list>
                    </div>
                </@layout.formGroup>


            <hr>
            <h4 style="display: inline-block;">${msg("withdrawalStep2_body1")}</h4>
            <h4 style="color: #ff0000; display: inline-block;">${msg("withdrawalSubmit")}</h4>
            <h4 style="display: inline-block;">${msg("withdrawalStep2_body2")}</h4>            
            <@layout.formButtonGroup>
                <div id="buttons">
                    <#if url.referrerURI??><a href="${(url.referrerURI!'')}">${kcSanitize(msg("backToApplication")?no_esc)}</a></#if>            
                    <button id="withdrawal-cancel-button"class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!} ${properties.kcButtonLargeClass!}" onclick="closeWithdrawalPage(); return false;">${msg("doCancel")}</button>                    
                    <button id="withdrawal-submit-button" class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}" onclick="submitWithdrawal(); return false;" disabled>${msg("doWithdrawal")}</button>                                
                </div>
            </@layout.formButtonGroup>
        </form>
    </div>
    <div id="withdrawal-success" class="hidden">    
        <@layout.contentHeader required=false; section>
            ${msg("withdrawalTitle")}
        </@layout.contentHeader>        
        </br>
        ${msg("withdrawalSucess_Message")}
        </br>        
        <hr>
        <div id="success-image">        
            <p class="image"></p>                            
        </div>
        <div id="success-text">
            <h3>${msg("withdrawalSucess_body1")}</h3>
            <h3>${msg("withdrawalSucess_body2")}</h3>
            <h3>${msg("withdrawalSucess_body3")}</h3>
            <div class="contact-info">
                <div class="contact-box">
                    ${msg("callCenter")}<br>
                    ${msg("supportEmail")}
                </div>
                <h3>${msg("withdrawalSucess_body4")}</h3>
                <h3>${msg("withdrawalSucess_body5")}</h3>
            </div>
        </div>
        <hr>
        <@layout.formButtonGroup>
            <div id="buttons">
                <#if url.referrerURI??><a href="${(url.referrerURI!'')}">${kcSanitize(msg("backToApplication")?no_esc)}</a></#if>            
                <button class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}" onclick="location.href='${url.logoutUrl}'">${msg("doOK")}</button>
            </div>
        </@layout.formButtonGroup>
    </div>            
    <div id="withdrawal-failure" class="hidden">    
        <@layout.contentHeader required=false; section>
            ${msg("withdrawalTitle")}
        </@layout.contentHeader>
        <div>
        </br>
        ${msg("withdrawalFailure_Message")}
        </br> 
        <hr>       
        <div id="failure-image">
            <p class="image"></p>             
        </div>
        <div id="failure-text">
            <h3 id="disableService">${msg("withdrawalFailure_body1")}</h3>
            <h3>${msg("withdrawalFailure_body2")}</h3>
            <div class="contact-info">
                ${msg("callCenter")}<br>
                ${msg("supportEmail")}
            </div>            
        </div>        
        <hr>
        <@layout.formButtonGroup>
            <div id="buttons">
                <#if url.referrerURI??><a href="${(url.referrerURI!'')}">${kcSanitize(msg("backToApplication")?no_esc)}</a></#if>            
                <button class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}" onclick="location.href='${url.accountUrl}'">${msg("doOK")}</button>
            </div>
        </@layout.formButtonGroup>    
    </div>    
<#--
    </br>
    <hr>
    </br>

    <#assign withdrawalUrl = url.accountUrl?replace("^(.*)(/account/?)(\\?(.*))?$", "$1/console/withdrawal?$4", 'r') />
    <form id="withdrawalUrl" action="${withdrawalUrl}" class="form-horizontal" method="post" enctype="multipart/form-data">
        <input type="hidden" name="stateChecker" value="${stateChecker}">
        <div class="form-group">
            <div id="kc-form-buttons" class="withdrawalCancel">
                <div class="">
                    ${msg("withdrawalHtmlBody")} <button href="" style="" type="submit" class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} " name="submitAction" value="Save" onclick="document.getElementById('withdrawalUrl').submit()">${msg("withdrawalAccount")}</button>
                </div>
            </div>
        </div>
    </form>
-->


<#--  kakao lib -->
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<#--  naver lib -->
<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>

<script type="text/javascript" src="${url.resourcesPath}/js/axios.min.js"></script>
<script type="text/javascript" src="${url.resourcesPath}/js/account.js"></script>
<#if properties.scripts_account_superauth?has_content>
    <#list properties.scripts_account_superauth?split(' ') as script>
        <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
    </#list>
</#if>
<script type="text/javascript" src="${url.resourcesPath}/js/sns.js"></script>
</@layout.mainLayout>
