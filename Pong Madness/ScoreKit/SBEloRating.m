/*
 Copyright (C) 2012 Stig Brautaset. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
   to endorse or promote products derived from this software without specific
   prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SBEloRating.h"

@implementation SBEloRating

- (id)initWithStrategy:(id<SBKFactorStrategy>)strategy_ {
    self = [super init];
    if (self) {            
        strategy = strategy_;
    }
    return self;
}

- (double)q:(NSUInteger)r {
    return pow(10.0, r / 400.0);
}

- (NSUInteger)initialRating {
    return [strategy initialRating];
}

- (double)expectedScoreForPlayerRating:(NSUInteger)playerRating
                  againstOpponentRating:(NSUInteger)opponentRating
{
    double qa = [self q:playerRating];
    double qb = [self q:opponentRating];
    return qa / (qa + qb);
}

- (NSUInteger)adjustedRatingForPlayerWithCompletedGames:(NSUInteger)games
                                              andRating:(NSUInteger)playerRating
                                                scoring:(double)result
                                  againstOpponentRating:(NSUInteger)opponentRating
{
    double e = [self expectedScoreForPlayerRating:playerRating againstOpponentRating:opponentRating];
    double K = [strategy kFactorForRating:playerRating andNumberOfGames:games];
    return (NSUInteger)(playerRating + K * (result - e));
}
@end
