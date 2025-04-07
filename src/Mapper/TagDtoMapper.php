<?php

namespace App\Mapper;

use App\Dto\TagDto;
use App\Repository\TagRepository;
use Symfony\Component\Uid\Uuid;

/**
 * Inspired by https://github.com/DesignPatternsPHP/DesignPatternsPHP/tree/main/Structural/DataMapper.
 */
readonly class TagDtoMapper
{
    public function __construct(private TagRepository $tagRepository)
    {
    }

    public function findOneById(string $id): TagDto
    {
        return $this->mapRowToDto($this->tagRepository->findOneByIdWithPostsCount($id));
    }

    /**
     * @return array<TagDto>
     */
    public function findAllWithPostsCount(): array
    {
        return array_map(
            fn ($row) => $this->mapRowToDto($row),
            $this->tagRepository->findAllWithPostsCount()
        );
    }

    /**
     * @param array{t_id: Uuid, t_name: string, p_count: int} $row
     */
    public function mapRowToDto(array $row): TagDto
    {
        return new TagDto(
            $row['t_id'],
            $row['t_name'],
            $row['p_count'],
        );
    }
}
