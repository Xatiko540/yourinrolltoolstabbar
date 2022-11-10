import 'dart:collection';

import 'package:yourinrolltoolstabbar_example/common_libs.dart';
import 'package:yourinrolltoolstabbar_example/logic/common/string_utils.dart';
import 'package:yourinrolltoolstabbar_example/logic/data/artifact_data.dart';
import 'package:yourinrolltoolstabbar_example/logic/met_api_service.dart';

import 'package:yourinrolltoolstabbar_example/logic/common/http_client.dart';

class MetAPILogic {
  final HashMap<String, ArtifactData?> _artifactCache = HashMap();

  MetAPIService get service => GetIt.I.get<MetAPIService>();

  /// Returns artifact data by ID. Returns null if artifact cannot be found. */
  Future<ArtifactData?> getArtifactByID(String id) async {
    if (_artifactCache.containsKey(id)) return _artifactCache[id];
    ServiceResult<ArtifactData?> result = (await service.getObjectByID(id));
    if (!result.success) throw StringUtils.supplant($strings.artifactDetailsErrorNotFound, {'{artifactId}': id});
    ArtifactData? artifact = result.content;
    return _artifactCache[id] = artifact;
  }
}
