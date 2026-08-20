import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/config/config.dart';
import 'package:noriskclient/main.dart';
import 'package:noriskclient/services/api_client.dart';
import 'package:noriskclient/models/report_types.dart';
import 'package:noriskclient/l10n/app_localizations.dart';
import 'package:noriskclient/widgets/common/nr_back_button.dart';
import 'package:noriskclient/widgets/common/nr_button.dart';
import 'package:noriskclient/widgets/common/nr_checkbox.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';

class ReportMcReal extends StatefulWidget {
  const ReportMcReal({super.key, required this.type, required this.contentId});

  final ReportType type;
  final String contentId;

  @override
  State<ReportMcReal> createState() => ReportMcRealState();
}

class ReportMcRealState extends State<ReportMcReal> {
  bool obscenity = false;
  bool hateSpeech = false;
  bool copyrightInfringement = false;
  bool privacyViolation = false;
  bool spamOrFraud = false;
  bool inappropriateForMinors = false;
  bool other = false;
  Map<String, dynamic> userData = getUserData;

  final TextEditingController infoController = TextEditingController();
  final FocusNode infoFocus = FocusNode();
  bool hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: NoRiskClientColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Stack(
              children: [
                Center(
                  child: NoRiskText(
                    widget.type == ReportType.POST
                        ? AppLocalizations.of(context)!.mcRealReport_title_post
                        : AppLocalizations.of(
                            context,
                          )!
                            .mcRealReport_title_comment,
                    spaceTop: false,
                    spaceBottom: false,
                    style: TextStyle(
                      color: NoRiskClientColors.text,
                      fontSize: widget.type == ReportType.POST ? 26 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: NoRiskBackButton(
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            NoRiskText(
              AppLocalizations.of(context)!.mcRealReport_whatHappened,
              textAlign: TextAlign.center,
              spaceTop: false,
              spaceBottom: false,
              style: TextStyle(
                color: NoRiskClientColors.text,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            NoRiskCheckbox(
              onChanged: (value) => setState(() {
                obscenity = value;
              }),
              name: AppLocalizations.of(context)!.mcRealReport_reason_obscenity,
            ),
            const SizedBox(height: 10),
            NoRiskCheckbox(
              onChanged: (value) => setState(() {
                hateSpeech = value;
              }),
              name: AppLocalizations.of(
                context,
              )!
                  .mcRealReport_reason_hateSpeach,
            ),
            const SizedBox(height: 10),
            NoRiskCheckbox(
              onChanged: (value) => setState(() {
                copyrightInfringement = value;
              }),
              name: AppLocalizations.of(
                context,
              )!
                  .mcRealReport_reason_copyrightInfringement,
            ),
            const SizedBox(height: 10),
            NoRiskCheckbox(
              onChanged: (value) => setState(() {
                privacyViolation = value;
              }),
              name: AppLocalizations.of(
                context,
              )!
                  .mcRealReport_reason_privacyViolation,
            ),
            const SizedBox(height: 10),
            NoRiskCheckbox(
              onChanged: (value) => setState(() {
                spamOrFraud = value;
              }),
              name: AppLocalizations.of(
                context,
              )!
                  .mcRealReport_reason_spamOrFraud,
            ),
            const SizedBox(height: 10),
            NoRiskCheckbox(
              onChanged: (value) => setState(() {
                inappropriateForMinors = value;
              }),
              name: AppLocalizations.of(
                context,
              )!
                  .mcRealReport_reason_inappropriateForMinors,
            ),
            const SizedBox(height: 10),
            NoRiskCheckbox(
              onChanged: (value) => setState(() {
                other = value;
              }),
              name: AppLocalizations.of(context)!.mcRealReport_reason_other,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 100,
              child: TextField(
                decoration: InputDecoration(
                  fillColor: NoRiskClientColors.surface,
                  labelText: AppLocalizations.of(
                    context,
                  )!
                      .mcRealReport_info_hint,
                  labelStyle: TextStyle(
                    color: NoRiskClientColors.text,
                    fontSize: 9,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      NoRiskClientColors.borderRadius,
                    ),
                    gapPadding: 1.5,
                    borderSide: BorderSide(
                      color: NoRiskClientColors.light,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      NoRiskClientColors.borderRadius,
                    ),
                    gapPadding: 1.5,
                    borderSide: BorderSide(
                      color: NoRiskClientColors.light,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  isDense: true,
                ),
                enabled: true,
                maxLines: 3,
                controller: infoController,
                focusNode: infoFocus,
                keyboardType: TextInputType.text,
                maxLength: Config.maxReportContentLength,
                cursorHeight: 12.5,
                style: TextStyle(color: NoRiskClientColors.text, fontSize: 10),
                autofocus: false,
                canRequestFocus: true,
                scrollPadding: const EdgeInsets.all(0),
                onSubmitted: (value) => infoFocus.unfocus(),
                onTapOutside: (event) => infoFocus.unfocus(),
              ),
            ),
            const SizedBox(height: 20),
            NoRiskButton(
              onTap: report,
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              child: NoRiskText(
                AppLocalizations.of(context)!.mcRealReport_report,
                spaceTop: false,
                spaceBottom: false,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> report() async {
    if (infoController.text.isEmpty) return;

    String reasons = '';
    if (obscenity) {
      reasons +=
          '&reasons=${ReportReason.OBSCENITY.toString().split('.').last}';
    }
    if (hateSpeech) {
      reasons +=
          '&reasons=${ReportReason.HATE_SPEECH.toString().split('.').last}';
    }
    if (copyrightInfringement) {
      reasons +=
          '&reasons=${ReportReason.COPYRIGHT_INFRINGEMENT.toString().split('.').last}';
    }
    if (privacyViolation) {
      reasons +=
          '&reasons=${ReportReason.PRIVACY_VIOLATION.toString().split('.').last}';
    }
    if (spamOrFraud) {
      reasons +=
          '&reasons=${ReportReason.SPAM_OR_FRAUD.toString().split('.').last}';
    }
    if (inappropriateForMinors) {
      reasons +=
          '&reasons=${ReportReason.INAPPROPRIATE_FOR_MINORS.toString().split('.').last}';
    }
    if (other) {
      reasons += '&reasons=${ReportReason.OTHER.toString().split('.').last}';
    }

    http.Response res = await http.post(
      Uri.parse(
        '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/${widget.type == ReportType.COMMENT ? 'comment' : 'post'}/${widget.contentId}/report?uuid=${userData['uuid']}$reasons&info=${infoController.text}',
      ),
      headers: {'Authorization': 'Bearer ${userData['token']}'},
    );
    if (res.statusCode != 200) {
      if (res.statusCode == 401) {
        Navigator.of(context).pop();
        getUpdateStream.sink.add(['signOut']);
      }
      return;
    }
    Navigator.of(context).pop();
  }
}
