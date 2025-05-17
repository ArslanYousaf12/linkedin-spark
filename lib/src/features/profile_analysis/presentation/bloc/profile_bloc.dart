import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:linkedinspark/src/features/profile_analysis/domain/linkedin_profile.dart';
import 'package:linkedinspark/src/features/profile_analysis/domain/profile_recommendation.dart';
import 'package:linkedinspark/src/features/profile_analysis/domain/profile_repository.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileUrlSubmitted extends ProfileEvent {
  final String url;

  const ProfileUrlSubmitted(this.url);

  @override
  List<Object?> get props => [url];
}

class ProfileFetchRequested extends ProfileEvent {
  const ProfileFetchRequested();
}

class RecommendationsRequested extends ProfileEvent {
  const RecommendationsRequested();
}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoadInProgress extends ProfileState {
  const ProfileLoadInProgress();
}

class ProfileLoadSuccess extends ProfileState {
  final LinkedInProfile profile;

  const ProfileLoadSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileLoadFailure extends ProfileState {
  final String message;

  const ProfileLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class RecommendationsLoadInProgress extends ProfileState {
  final LinkedInProfile profile;

  const RecommendationsLoadInProgress(this.profile);

  @override
  List<Object?> get props => [profile];
}

class RecommendationsLoadSuccess extends ProfileState {
  final LinkedInProfile profile;
  final ProfileRecommendation recommendations;

  const RecommendationsLoadSuccess({
    required this.profile,
    required this.recommendations,
  });

  @override
  List<Object?> get props => [profile, recommendations];
}

class RecommendationsLoadFailure extends ProfileState {
  final LinkedInProfile profile;
  final String message;

  const RecommendationsLoadFailure({
    required this.profile,
    required this.message,
  });

  @override
  List<Object?> get props => [profile, message];
}

// BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository,
      super(const ProfileInitial()) {
    on<ProfileUrlSubmitted>(_onProfileUrlSubmitted);
    on<ProfileFetchRequested>(_onProfileFetchRequested);
    on<RecommendationsRequested>(_onRecommendationsRequested);
  }

  Future<void> _onProfileUrlSubmitted(
    ProfileUrlSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    if (!_profileRepository.isValidLinkedInUrl(event.url)) {
      emit(
        const ProfileLoadFailure('Please enter a valid LinkedIn profile URL'),
      );
      return;
    }

    emit(const ProfileLoadInProgress());

    try {
      final profile = await _profileRepository.fetchProfileFromUrl(event.url);
      await _profileRepository.saveProfile(profile);
      emit(ProfileLoadSuccess(profile));
    } catch (e) {
      emit(ProfileLoadFailure(e.toString()));
    }
  }

  Future<void> _onProfileFetchRequested(
    ProfileFetchRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoadInProgress());

    try {
      final profile = await _profileRepository.getSavedProfile();
      if (profile != null) {
        emit(ProfileLoadSuccess(profile));
      } else {
        emit(const ProfileInitial());
      }
    } catch (e) {
      emit(ProfileLoadFailure(e.toString()));
    }
  }

  Future<void> _onRecommendationsRequested(
    RecommendationsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoadSuccess) {
      emit(RecommendationsLoadInProgress(currentState.profile));

      try {
        final recommendations = await _profileRepository
            .generateRecommendations(currentState.profile);
        await _profileRepository.saveRecommendations(recommendations);

        emit(
          RecommendationsLoadSuccess(
            profile: currentState.profile,
            recommendations: recommendations,
          ),
        );
      } catch (e) {
        emit(
          RecommendationsLoadFailure(
            profile: currentState.profile,
            message: e.toString(),
          ),
        );
      }
    }
  }
}
