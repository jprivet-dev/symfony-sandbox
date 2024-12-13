<?php

namespace App\Repository;

use App\Dto\TagPostsCountDto;
use App\Entity\Tag;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\ORM\QueryBuilder;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Tag>
 */
class TagRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Tag::class);
    }

    /**
     * @return array<TagPostsCountDto>
     */
    public function findAllWithPostsCount(): array
    {
        $qb = $this->createQueryBuilder('t');
        static::addPostsCount($qb);
        static::orderByTagNameAsc($qb);

        return static::getArrayTagPostsCountDto($qb->getQuery()->getScalarResult());
    }

    private static function addPostsCount(QueryBuilder $qb): void
    {
        $qb
            ->leftJoin('t.posts', 'p')
            ->addSelect('COUNT(t.id) as p_count')
            ->groupBy('t.id');
    }

    private static function orderByTagNameAsc(QueryBuilder $qb): void
    {
        $qb->orderBy('t.name', 'ASC');
    }

    /**
     * @param array<string, mixed> $scalarResult
     *
     * @return array<TagPostsCountDto>
     */
    private static function getArrayTagPostsCountDto(array $scalarResult): array
    {
        return array_map(
            fn ($item) => new TagPostsCountDto(
                $item['t_id'],
                $item['t_name'],
                $item['p_count'],
            ),
            $scalarResult
        );
    }
}
